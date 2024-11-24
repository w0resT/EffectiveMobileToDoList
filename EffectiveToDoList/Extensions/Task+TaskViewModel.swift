import Foundation

extension Task {
    init(taskViewModel: TaskViewModel) {
        id = taskViewModel.id
        title = taskViewModel.title
        description = taskViewModel.description
        isCompleted = taskViewModel.isCompleted
        
        dateCreated = DateFormatterHelper.date(from: taskViewModel.formattedDate) ?? Date.now
    }
}
