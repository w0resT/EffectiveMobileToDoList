import Foundation

extension Task {
    init(taskDTO: TaskDTO) {
        self.id = taskDTO.id
        self.title = taskDTO.todo
        self.description = nil
        self.isCompleted = taskDTO.completed
        self.dateCreated = Date.now
    }
}
