import Foundation

class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Public Propeties
    weak var presenter: TaskListInteractorOutputProtocol?
    
    // MARK: - Private Properties
    var networkManager: NetworkManagerProtocol?
    // storage
    
    // MARK: - TaskListInteractorProtocol
    func fetchTasks() {     
        networkManager?.fetchTasks(completion: { result in
            switch result {
            case .success(let rawTasks):
                let tasks = rawTasks.todos.map { Task(taskDTO: $0) }
                self.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self.presenter?.didFailToFetchTasks(error.localizedDescription)
            }
        })
    }
    
    func addTask(_ task: Task) {
        // storageManager...
    }
    
    func removeTask(_ task: Task) {
        // storageManager...
    }
    
    func updateTaskStatus(_ task: Task) {
        // storageManager...
    }
}
