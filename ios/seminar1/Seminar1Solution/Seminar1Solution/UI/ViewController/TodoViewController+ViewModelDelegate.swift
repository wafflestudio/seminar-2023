//
//  TodoViewController+ViewModelDelegate.swift
//  Seminar1Solution
//
//  Created by user on 2023/10/04.
//

import UIKit

extension TodoViewController: TodoViewControllerViewModelDelegate {
    func todoViewControllerViewModel(_ viewModel: TodoViewControllerViewModel, didInsertTodoViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .none)
        if let cell = tableView.cellForRow(at: indexPath) as? TodoCell {
            cell.titleBecomeFirstResponder()
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        updateUnavailableView()
    }

    func todoViewControllerViewModel(_ viewModel: TodoViewControllerViewModel, didRemoveTodoViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath, options: ReloadOptions) {
        if options.contains(.reload) {
            let animated = options.contains(.animated)
            tableView.deleteRows(at: [indexPath], with: animated ? .automatic : .none)
        }
        updateUnavailableView()
    }
}
