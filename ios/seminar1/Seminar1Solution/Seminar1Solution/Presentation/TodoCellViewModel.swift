//
//  TodoCellViewModel.swift
//  Seminar1Solution
//
//  Created by user on 2023/10/04.
//

import Foundation

class TodoCellViewModel {
    private var todoItem: TodoItem
    weak var delegate: (any TodoCellViewModelDelegate)?

    init(todoItem: TodoItem) {
        self.todoItem = todoItem
    }

    var id: UUID {
        todoItem.id
    }

    var isComplete: Bool {
        get { todoItem.isComplete }
        set {
            todoItem.isComplete = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todoItem)
        }
    }

    var title: String {
        get { todoItem.title }
        set {
            todoItem.title = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todoItem)
        }
    }

    var memo: String? {
        get { todoItem.memo }
        set {
            todoItem.memo = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todoItem)
        }
    }

    var isMemoHidden: Bool {
        todoItem.memo == nil
    }

    func addNewTodoItem() {
        delegate?.todoCellViewModelDidReturnTitle(self)
    }

    func endEditingTitle(with title: String?) {
        delegate?.todoCellViewModel(self, didEndEditingWith: title)
    }
}

protocol TodoCellViewModelDelegate: AnyObject {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didUpdateItem: TodoItem)
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel)
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingWith title: String?)
}
