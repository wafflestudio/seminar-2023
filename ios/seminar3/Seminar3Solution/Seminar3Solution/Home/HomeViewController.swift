//
//  HomeViewController.swift
//  Seminar3Solution
//
//  Created by user on 2023/10/28.
//

import UIKit
import Combine
import Kingfisher

enum HomeSection {
    case main
}

class HomeViewController: UIViewController {
    private let viewModel: HomeViewControllerViewModel

    init(viewModel: HomeViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var movieListDataSource: UICollectionViewDiffableDataSource<HomeSection, HomeMovieCellViewModel.ID>!
    private var cancellables = Set<AnyCancellable>()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = movieListDataSource
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Home"

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        configureDataSource()
        bindDataSource()
        setupSearchController()
        Task {
            await viewModel.fetchInitialNowPlayingMovies()
        }

    }

    private func bindDataSource() {
        viewModel.movieViewModels
            .receive(on: DispatchQueue.main)
            .map { viewModels in
                viewModels.map({ $0.id }).uniqued()
            }
            .sink { (ids: Array<HomeMovieCellViewModel.ID>) in
                var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeMovieCellViewModel.ID>()
                snapshot.appendSections([.main])
                snapshot.appendItems(ids, toSection: .main)
                self.movieListDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }

    private func configureDataSource() {
        movieListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView)
        { [weak self] collectionView, indexPath, itemIdentifier -> HomeCollectionViewCell in
            guard let self else { fatalError() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCollectionViewCell else { fatalError() }
            let movieViewModel = viewModel.viewModel(at: indexPath)
            cell.configure(with: movieViewModel)
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width / 4, height: 130)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let fetchedCount = viewModel.numberOfRows()
        print("indexPath.row:\(indexPath.row) fetchedCount:\(fetchedCount)")
        guard indexPath.row >= fetchedCount - 1 else { return }
        Task { @MainActor in
            await viewModel.fetchMoreNowPlayingMovies()
        }
    }

}

extension HomeViewController {
    func setupSearchController() {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.placeholder = "Search Movies"
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchResultsUpdater = self
        searchController.delegate = self
            navigationItem.searchController = searchController
            navigationItem.title = "Search"
            navigationItem.hidesSearchBarWhenScrolling = false
        }
}

extension HomeViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(query: searchController.searchBar.text ?? "")
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        print("\(#function)")
        Task {
            await viewModel.fetchInitialNowPlayingMovies()
        }
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
