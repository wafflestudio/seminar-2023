import UIKit
import SnapKit

class TodoViewController: UIViewController {
    private lazy var todoViewControllerViewModel = {
        let viewModel = TodoViewControllerViewModel(repository: TodoItemRepository())
        viewModel.delegate = self
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "할 일"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupLayout()
        registerCells()
        updateUnavailableView()
        registerKeyboardNotification()
    }

    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    lazy var tableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        tableView.separatorInset = .init(top: 0, left: 40, bottom: 0, right: 0)
        tableView.separatorColor = .tertiaryLabel
        tableView.tableHeaderView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap(_:)))
        tableView.addGestureRecognizer(tapGesture)
        return tableView
    }()

    private lazy var unavailableView: UIView = {
        let view = UIView()
        let label = UILabel()
        view.isUserInteractionEnabled = false
        label.text = "미리 알림 없음"
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()

    func updateUnavailableView() {
        unavailableView.isHidden = todoViewControllerViewModel.numberOfItems != 0
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(unavailableView)
        unavailableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func registerCells() {
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
    }

    @objc private func handleTableViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: tableView)
        if location.y > tableView.contentSize.height {
            let success = todoViewControllerViewModel.appendPlaceholderIfNeeded()
            if !success {
                tableView.endEditing(false)
            }
        }
    }
}

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoViewControllerViewModel.remove(at: indexPath)
        }
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoViewControllerViewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else { fatalError() }
        cell.selectionStyle = .none
        guard let viewModel = todoViewControllerViewModel.viewModel(at: indexPath) else { return cell }
        viewModel.delegate = todoViewControllerViewModel
        cell.configure(with: viewModel)
        return cell
    }
}
