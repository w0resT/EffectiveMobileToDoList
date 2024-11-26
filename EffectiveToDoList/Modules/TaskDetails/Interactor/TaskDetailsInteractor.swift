import Foundation

class TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    
    // MARK: - Public Propeties
    weak var presenter: TaskDetailsInteractorOutputProtocol?
    
    // MARK: - Initializers
    init(presenter: TaskDetailsInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }
    
    // MARK: - TaskDetailsInteractorProtocol
    func saveAndNavigationBack(_ task: Task) {
        // Или использовать storageManager и сохранить в CoreData,
        // но нужно оповещение для TaskList: Combine/RxSwift, KVO, NotificationCenter
        if isTaskEmpty(task) {
            presenter?.navigateBack()
        } else {
            presenter?.delegateAndNavigateBack(task)
        }
    }
}

// MARK: - Helpers
private extension TaskDetailsInteractor {
    func isTaskEmpty(_ task: Task) -> Bool {
        return task.title.isEmpty && (task.description?.isEmpty ?? true)
    }
}
