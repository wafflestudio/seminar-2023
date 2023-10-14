//
//  TodoItemRepository.swift
//  Seminar1Solution
//
//  Created by user on 2023/10/04.
//

import Foundation

class TodoItemRepository: TodoItemRepositoryProtocol {
    private var todoItems = [TodoItem]()

    var numberOfItems: Int {
        todoItems.count
    }

    func indexPath(with id: UUID) -> IndexPath? {
        guard let firstIndex = todoItems.firstIndex(where: { $0.id == id }) else { return nil }
        return .init(row: firstIndex, section: 0)
    }

    func get(with id: UUID) -> TodoItem? {
        guard let indexPath = indexPath(with: id) else { return nil }
        return get(at: indexPath)
    }

    func get(at indexPath: IndexPath) -> TodoItem? {
        return todoItems[safe: indexPath.row]
    }

    func append(_ todoItem: TodoItem) {
        todoItems.append(todoItem)
    }

    func insert(_ todoItem: TodoItem, at indexPath: IndexPath) {
        todoItems.insert(todoItem, at: indexPath.row)
    }

    func remove(_ todoItem: TodoItem) {
        guard let indexPath = indexPath(with: todoItem.id) else { return }
        todoItems.remove(at: indexPath.row)
    }

    func update(_ newValue: TodoItem) {
        guard let indexPath = indexPath(with: newValue.id) else { return }
        todoItems[indexPath.row] = newValue
        print("updated to new value:\(newValue) at \(indexPath)")
    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
