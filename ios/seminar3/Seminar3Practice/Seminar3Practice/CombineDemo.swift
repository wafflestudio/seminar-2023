//
//  CombineDemo.swift
//  Seminar3Practice
//
//  Created by user on 2023/10/29.
//

import Foundation
import Combine

class CombineDemo {

    let userInput = CurrentValueSubject<String, Never>("")
    var cancellables = Set<AnyCancellable>()

    func combineUserInput() {
        // subscribe
        userInput
            .sink { string in
                print("handling \(string)")
            }
            .store(in: &cancellables)
        
        // publish
        Task {
            for char in "hello" {
                try? await Task.sleep(for: .seconds(1))
                userInput.send(userInput.value + String(char))
            }
        }
    }

    func combineUserInputWithOperators() {
        // subscribe
        userInput
            .filter { char in
                let isEmpty = char.trimmingCharacters(in: .whitespaces).isEmpty
                return !isEmpty
            }
            .sink { string in
                print("handling \(string)")
            }
            .store(in: &cancellables)

        // publish
        Task {
            for char in "h    e  l l   o" {
                try? await Task.sleep(for: .seconds(0.1))
                userInput.send(String(char))
            }
        }
    }

    func combineUserInputWithDebounce() {

    }
}
