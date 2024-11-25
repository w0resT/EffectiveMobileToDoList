import Foundation

struct TaskListViewModel  {
    var id: Int
    var title: String
    var description: String?
    var formattedDate: String
    var isCompleted: Bool
}

extension TaskListViewModel {
    init(task: Task) {
        self.id = task.id
        self.title = task.title
        self.description = task.description
        self.formattedDate = DateFormatterHelper.string(from: task.dateCreated)
        self.isCompleted = task.isCompleted
    }
}

