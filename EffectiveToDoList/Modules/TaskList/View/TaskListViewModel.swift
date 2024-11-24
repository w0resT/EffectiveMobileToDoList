import Foundation

struct TaskViewModel  {
    var id: Int
    var title: String
    var description: String?
    var formattedDate: String
    var isCompleted: Bool
}

extension TaskViewModel {
    init(task: Task) {
        id = task.id
        title = task.title
        description = task.description
        formattedDate = DateFormatterHelper.string(from: task.dateCreated)
        isCompleted = task.isCompleted
    }
}
