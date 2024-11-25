import Foundation

class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Public Propeties
    weak var presenter: TaskListInteractorOutputProtocol?
    
    // MARK: - Private Properties
    private var networkManager: NetworkManagerProtocol?
    private var storageManager: StorageManagerProtocol?
    
    // MARK: - Initializers
    init(presenter: TaskListInteractorOutputProtocol? = nil, networkManager: NetworkManagerProtocol? = nil, storageManager: StorageManagerProtocol? = nil) {
        self.presenter = presenter
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    // MARK: - TaskListInteractorProtocol
    func loadTasksOnAppLaunch() {
        storageManager?.hasTasks(completion: { result in
            switch result {
            case .success(let hasTasks):
                hasTasks ? self.fetchTasks() : self.fetchTasksNetwork()
            case .failure(let error):
                self.presenter?.didFailToLoadTasksOnAppLaunch(error.localizedDescription)
            }
        })
    }
    
    func fetchTasksNetwork() {
        networkManager?.fetchTasks(completion: { result in
            switch result {
            case .success(let rawTasks):
                let tasks = rawTasks.todos.map { Task(taskDTO: $0) }
                self.presenter?.didFetchTasksNetwork(tasks)
            case .failure(let error):
                self.presenter?.didFailToFetchTasksNetwork(error.localizedDescription)
            }
        })
    }
    
    func fetchTasks() {
        storageManager?.fetchTasks(completion: { result in
            switch result {
            case .success(let tasks):
                self.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self.presenter?.didFailToFetchTasks(error.localizedDescription)
            }
        })
    }
    
    func createTask(_ task: Task) {
        storageManager?.createTask(task, completion: { result in
            switch result {
            case .success(let tasks):
                self.presenter?.didCreateTask(tasks)
            case .failure(let error):
                self.presenter?.didFailToCreateTask(error.localizedDescription)
            }
        })
    }
    
    func deleteTask(_ task: Task) {
        storageManager?.deleteTask(task, completion: { result in
            switch result {
            case .success(let tasks):
                self.presenter?.didDeleteTask(tasks)
            case .failure(let error):
                self.presenter?.didFailToDeleteTask(error.localizedDescription)
            }
        })
    }
    
    func updateTask(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        
        storageManager?.updateTask(updatedTask, completion: { result in
            switch result {
            case .success(let tasks):
                self.presenter?.didUpdateTask(tasks)
            case .failure(let error):
                self.presenter?.didFailToUpdateTask(error.localizedDescription)
            }
        })
    }
    
    func createOrUpdateTask(_ task: Task) {
        storageManager?.createOrUpdateTask(task, completion: { result in
            switch result {
            case .success(let tasks):
                self.presenter?.didCreateOrUpdateTask(tasks)
            case .failure(let error):
                self.presenter?.didFailToCreateOrUpdateTask(error.localizedDescription)
            }
        })
    }
    
    func createOrUpdateTasks(_ tasks: [Task]) {
        storageManager?.createOrUpdateTasks(tasks, completion: { result in
            switch result {
            case .success(let tasks):
                self.presenter?.didCreateOrUpdateTasks(tasks)
            case .failure(let error):
                self.presenter?.didFailToCreateOrUpdateTasks(error.localizedDescription)
            }
        })
    }
    
    func fetchFilteredTasks(_ text: String) {
        if text.isEmpty {
            storageManager?.fetchTasks(completion: { result in
                switch result {
                case .success(let tasks):
                    self.presenter?.didFetchFilteredTasks(tasks)
                case .failure(let error):
                    self.presenter?.didFailToFetchFilteredTasks(error.localizedDescription)
                }
            })
        } else {
            storageManager?.fetchFilteredTasks(text, completion: { result in
                switch result {
                case .success(let tasks):
                    self.presenter?.didFetchFilteredTasks(tasks)
                case .failure(let error):
                    self.presenter?.didFailToFetchFilteredTasks(error.localizedDescription)
                }
            })
        }
    }
}
