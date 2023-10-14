import Foundation

class TodoViewControllerViewModel {
    weak var delegate: (any TodoViewControllerViewModelDelegate)?
    private var todoRepository: any TodoItemRepositoryProtocol

    init(repository: some TodoItemRepositoryProtocol) {
        self.todoRepository = repository
    }

    var viewModels = [UUID: TodoCellViewModel]()

    private func todoItem(at indexPath: IndexPath) -> TodoItem? {
        todoRepository.get(at: indexPath)
    }

    func viewModel(at indexPath: IndexPath) -> TodoCellViewModel? {
        guard let item = todoItem(at: indexPath) else { return nil }
        return viewModel(with: item)
    }

    func viewModel(with item: TodoItem) -> TodoCellViewModel? {
        if let viewModel = viewModels[item.id] {
            return viewModel
        }
        return nil
    }

    var numberOfItems: Int {
        todoRepository.numberOfItems
    }

    func insert(_ todoItem: TodoItem, at indexPath: IndexPath) {
        todoRepository.insert(todoItem, at: indexPath)
        let newViewModel = {
            if let viewModel = viewModel(with: todoItem) {
                return viewModel
            }
            let newViewModel = TodoCellViewModel(todoItem: todoItem)
            viewModels[newViewModel.id] = newViewModel
            return newViewModel
        }()

        delegate?.todoViewControllerViewModel(self, didInsertTodoViewModel: newViewModel, at: indexPath)
    }

    func append(_ todoItem: TodoItem) {
        insert(todoItem, at: .init(row: numberOfItems, section: 0))
    }

    func remove(at indexPath: IndexPath) {
        guard let todoItem = todoItem(at: indexPath), let viewModel = viewModel(with: todoItem) else { return }
        todoRepository.remove(todoItem)
        viewModels.removeValue(forKey: todoItem.id)
        delegate?.todoViewControllerViewModel(self, didRemoveTodoViewModel: viewModel, at: indexPath, options: [.reload])
    }
}

extension TodoViewControllerViewModel {
    func appendPlaceholderIfNeeded() -> Bool {
        if numberOfItems == 0 {
            append(.placeholderItem())
            return true
        }

        guard let lastItem = todoRepository.get(at: .init(row: numberOfItems - 1, section: 0)) else { return false }
        if !lastItem.title.isEmpty {
            append(.placeholderItem())
            return true
        }

        return false
    }
}

extension TodoViewControllerViewModel: TodoCellViewModelDelegate {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingWith title: String?) {
        if title == nil || title?.isEmpty == true {
            guard let indexPath = todoRepository.indexPath(with: viewModel.id) else { return }
            remove(at: indexPath)
        }
    }
    
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel) {
        appendPlaceholderIfNeeded()
    }
    
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didUpdateItem todoItem: TodoItem) {
        guard let indexPath = todoRepository.indexPath(with: viewModel.id) else { return }
        todoRepository.update(todoItem)
    }

}


struct ReloadOptions: OptionSet {
    let rawValue: Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static let reload = ReloadOptions(rawValue: 1 << 1)
    static let animated = ReloadOptions(rawValue: 1 << 2)
}

protocol TodoViewControllerViewModelDelegate: AnyObject {
    func todoViewControllerViewModel(
        _ viewModel: TodoViewControllerViewModel,
        didInsertTodoViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath
    )

    func todoViewControllerViewModel(
        _ viewModel: TodoViewControllerViewModel,
        didRemoveTodoViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath,
        options: ReloadOptions
    )
}
