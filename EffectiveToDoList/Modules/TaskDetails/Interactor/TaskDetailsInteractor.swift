import Foundation

class TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    
    // MARK: - Public Propeties
    weak var presenter: TaskDetailsInteractorOutputProtocol?
    
    // MARK: - TaskDetailsInteractorProtocol
    func createOrUpdateTask(_ task: Task) {
        if isTaskEmpty(task) {
            presenter?.navigateBack()
        } else {
            presenter?.delegateAndNavigateBack(task)
            
            // Или использовать storageManager и сохранить в CoreData, 
            // но нужно оповещение для TaskList: Combine/RxSwift, KVO, NotificationCenter
        }
    }
}

// MARK: - Helpers
private extension TaskDetailsInteractor {
    func isTaskEmpty(_ task: Task) -> Bool {
        return task.title.isEmpty && (task.description?.isEmpty ?? true)
    }
}
