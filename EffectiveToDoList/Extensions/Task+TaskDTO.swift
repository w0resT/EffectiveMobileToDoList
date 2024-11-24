import Foundation

extension Task {
    init(taskDTO: TaskDTO) {
        id = taskDTO.id
        title = taskDTO.todo
        description = nil
        isCompleted = taskDTO.completed
        dateCreated = Date.now
    }
}
