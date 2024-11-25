import Foundation

extension Task {
    init(taskViewModel: TaskListViewModel) {
        self.id = taskViewModel.id
        self.title = taskViewModel.title
        self.description = taskViewModel.description
        self.isCompleted = taskViewModel.isCompleted
        self.dateCreated = DateFormatterHelper.date(from: taskViewModel.formattedDate) ?? Date.now
    }
}
