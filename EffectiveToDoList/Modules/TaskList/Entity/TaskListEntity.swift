import Foundation

struct Task {
    var id: Int
    var title: String
    var description: String?
    var dateCreated: Date
    var isCompleted: Bool
}

extension Task {
    init() {
        self.id = 0
        self.title = ""
        self.description = nil
        self.dateCreated = Date.now
        self.isCompleted = false
    }
}
