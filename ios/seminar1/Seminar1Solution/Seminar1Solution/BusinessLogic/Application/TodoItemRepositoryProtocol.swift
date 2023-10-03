//
//  TodoItemRepositoryProtocol.swift
//  Seminar1Solution
//
//  Created by user on 2023/10/04.
//

import Foundation

protocol TodoItemRepositoryProtocol {
    var numberOfItems: Int { get }
    func get(with id: UUID) -> TodoItem?
    func get(at indexPath: IndexPath) -> TodoItem?
    func indexPath(with id: UUID) -> IndexPath?
    func append(_ todoItem: TodoItem)
    func insert(_ todoItem: TodoItem, at indexPath: IndexPath)
    func remove(_ todoItem: TodoItem)
    func update(_ todoItem: TodoItem)
}
