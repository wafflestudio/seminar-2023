//
//  EraseToAnyPublisherDemo.swift
//  Seminar3Practice
//
//  Created by user on 2023/10/29.
//

import Combine
import Foundation

// A simple data model for demonstration purposes.
struct Item {
    let name: String
}

class SomeViewModel {
    // Private subject
    private var itemsSubject = CurrentValueSubject<[Item], Never>([])

    // Public publisher
    var items: AnyPublisher<[Item], Never> {
        return itemsSubject.eraseToAnyPublisher()
    }

    // Function to add an item
    func addItem(_ item: Item) {
        var currentItems = itemsSubject.value
        currentItems.append(item)
        itemsSubject.send(currentItems)
    }
}

class SomeViewController {
    var cancellable: AnyCancellable?

    init(dataManager: SomeViewModel) {
        cancellable = dataManager.items.sink { items in
            print("Received items: \(items.map { $0.name })")
        }
    }
}

class EraseToAnyPublisherDemo {

    let viewModel = SomeViewModel()
    lazy var viewController = SomeViewController(dataManager: viewModel)

    func start() {
        _ = viewController // init
        viewModel.addItem(Item(name: "Item 1"))
        viewModel.addItem(Item(name: "Item 2"))
    }
}


// Adding items
