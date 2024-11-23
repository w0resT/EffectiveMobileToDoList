import Foundation

struct TaskViewModel  {
    var id: Int
    var title: String
    var description: String?
    var formattedDate: String
    var isCompleted: Bool
    
    init(task: Task) {
        id = task.id
        title = task.title
        description = task.description
        formattedDate = DateFormatterHelper.string(from: task.dateCreated)
        isCompleted = task.isCompleted
    }
}

extension Task {
    init(taskViewModel: TaskViewModel) {
        id = taskViewModel.id
        title = taskViewModel.title
        description = taskViewModel.description
        isCompleted = taskViewModel.isCompleted
        
        dateCreated = DateFormatterHelper.date(from: taskViewModel.formattedDate) ?? Date.now
    }
}
