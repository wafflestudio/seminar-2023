//
//  SubjectDemo.swift
//  Seminar3Practice
//
//  Created by user on 2023/10/29.
//

import Combine
import Foundation

class SubjectsDemo {
    var cancellables: Set<AnyCancellable> = []

    // PassthroughSubject
    let passthrough = PassthroughSubject<String, Never>()

    // CurrentValueSubject with an initial value
    let currentValue = CurrentValueSubject<String, Never>("Initial Value")

    func demo() {
        // Subscribe to PassthroughSubject
        passthrough.sink { value in
            print("Passthrough received: \(value)")
        }
        .store(in: &cancellables)

        // Subscribe to CurrentValueSubject
        currentValue.sink { value in
            print("CurrentValue received: \(value)")
        }
        .store(in: &cancellables)

        // Send value through Passthrough
        passthrough.send("Passthrough 1")

        // Send value through CurrentValue
        currentValue.send("CurrentValue 1")

        // Let's add another subscriber to CurrentValueSubject
        // This will immediately receive the current value upon subscription
        currentValue.sink { value in
            print("New subscriber to CurrentValue received: \(value)")
        }
        .store(in: &cancellables)

        // Send another value through CurrentValue
        currentValue.send("CurrentValue 2")
    }
}
