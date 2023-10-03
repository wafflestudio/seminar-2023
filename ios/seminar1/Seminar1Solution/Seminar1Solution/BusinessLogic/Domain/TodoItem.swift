import Foundation

struct TodoItem: Codable, Identifiable {
    var id: UUID = .init()
    var title: String
    var memo: String?
    var isComplete: Bool
}

extension TodoItem {
    static func placeholderItem() -> Self {
        .init(title: "", memo: nil, isComplete: false)
    }
}
