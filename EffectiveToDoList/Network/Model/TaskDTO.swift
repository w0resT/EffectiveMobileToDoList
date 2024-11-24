import Foundation

struct TaskDTO: Decodable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
}

struct TaskListDTO: Decodable {
    var todos: [TaskDTO]
}

