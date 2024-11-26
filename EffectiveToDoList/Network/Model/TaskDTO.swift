import Foundation

struct TaskDTO: Codable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
}

struct TaskListDTO: Codable {
    var todos: [TaskDTO]
}

