import UIKit
import Combine

// Model
struct MyItem: Identifiable, Hashable {
    let id: UUID
    let name: String
}

// ViewModel
class ItemsViewModel {
    // Private subject
    private var itemsSubject = CurrentValueSubject<[MyItem], Never>([])

    // Public publisher
    var items: AnyPublisher<[MyItem], Never> {
        return itemsSubject.eraseToAnyPublisher()
    }

    func item(at indexPath: IndexPath) -> MyItem {
        itemsSubject.value[indexPath.row]
    }

    // Simulated data fetch and update
    func fetchAndUpdateData() {
        let newItem = MyItem(id: UUID(), name: "Item \(itemsSubject.value.count + 1)")
        var currentItems = itemsSubject.value
        currentItems.append(newItem)
        currentItems.shuffle() // shuffle existing items
        itemsSubject.send(currentItems)
    }
}

// ViewController
class ItemsViewController: UIViewController, UICollectionViewDelegate {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MyItem.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyItem.ID>

    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var dataSource: DataSource!
    var viewModel: ItemsViewModel = ItemsViewModel()
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        configureDataSource()
        bindViewModel()

        setupButton()
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }

    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, itemId) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .gray
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }  // Clear previous views

            let myItem = self.viewModel.item(at: indexPath)
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = myItem.name
            label.textAlignment = .center
            cell.contentView.addSubview(label)
            return cell
        }
    }

    func bindViewModel() {
        cancellable = viewModel.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(items.map { $0.id })
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
    }

    func setupButton() {
        let button = UIButton(frame: CGRect(x: (view.bounds.width - 200) / 2, y: view.bounds.height - 60, width: 200, height: 40))
        button.setTitle("Fetch & Update", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(fetchDataTapped), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func fetchDataTapped() {
        viewModel.fetchAndUpdateData()
    }
}
