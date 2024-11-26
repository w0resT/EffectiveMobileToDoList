import Foundation

class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Public Propeties
    weak var presenter: TaskListInteractorOutputProtocol?
    
    // MARK: - Private Properties
    private var networkManager: NetworkManagerProtocol?
    private var storageManager: StorageManagerProtocol?
    
    // MARK: - Initializers
    init(presenter: TaskListInteractorOutputProtocol? = nil, 
         networkManager: NetworkManagerProtocol? = nil,
         storageManager: StorageManagerProtocol? = nil) {
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
        let urlString = getTodosUrl()
        networkManager?.fetchTasks(urlString: urlString, completion: { result in
            switch result {
            case .success(let rawTasks):
                let tasks = rawTasks.todos.map { Task(taskDTO: $0) }
                let sortedTasks = self.getSortedTasks(tasks)
                self.presenter?.didFetchTasksNetwork(sortedTasks)
            case .failure(let error):
                self.presenter?.didFailToFetchTasksNetwork(error.localizedDescription)
            }
        })
    }
    
    func fetchTasks() {
        storageManager?.fetchTasks(completion: { result in
            switch result {
            case .success(let tasks):
                let sortedTasks = self.getSortedTasks(tasks)
                self.presenter?.didFetchTasks(sortedTasks)
            case .failure(let error):
                self.presenter?.didFailToFetchTasks(error.localizedDescription)
            }
        })
    }
    
    func createTask(_ task: Task) {
        storageManager?.createTask(task, completion: { result in
            switch result {
            case .success(let tasks):
                let sortedTasks = self.getSortedTasks(tasks)
                self.presenter?.didCreateTask(sortedTasks)
            case .failure(let error):
                self.presenter?.didFailToCreateTask(error.localizedDescription)
            }
        })
    }
    
    func deleteTask(_ task: Task) {
        storageManager?.deleteTask(task, completion: { result in
            switch result {
            case .success(let tasks):
                let sortedTasks = self.getSortedTasks(tasks)
                self.presenter?.didDeleteTask(sortedTasks)
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
                let sortedTasks = self.getSortedTasks(tasks)
                self.presenter?.didUpdateTask(sortedTasks)
            case .failure(let error):
                self.presenter?.didFailToUpdateTask(error.localizedDescription)
            }
        })
    }
    
    func createOrUpdateTask(_ task: Task) {
        storageManager?.createOrUpdateTask(task, completion: { result in
            switch result {
            case .success(let tasks):
                let sortedTasks = self.getSortedTasks(tasks)
                self.presenter?.didCreateOrUpdateTask(sortedTasks)
            case .failure(let error):
                self.presenter?.didFailToCreateOrUpdateTask(error.localizedDescription)
            }
        })
    }
    
    func createOrUpdateTasks(_ tasks: [Task]) {
        storageManager?.createOrUpdateTasks(tasks, completion: { result in
            switch result {
            case .success(let tasks):
                let sortedTasks = self.getSortedTasks(tasks)
                self.presenter?.didCreateOrUpdateTasks(sortedTasks)
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
                    let sortedTasks = self.getSortedTasks(tasks)
                    self.presenter?.didFetchFilteredTasks(sortedTasks)
                case .failure(let error):
                    self.presenter?.didFailToFetchFilteredTasks(error.localizedDescription)
                }
            })
        } else {
            storageManager?.fetchFilteredTasks(text, completion: { result in
                switch result {
                case .success(let tasks):
                    let sortedTasks = self.getSortedTasks(tasks)
                    self.presenter?.didFetchFilteredTasks(sortedTasks)
                case .failure(let error):
                    self.presenter?.didFailToFetchFilteredTasks(error.localizedDescription)
                }
            })
        }
    }
}

private extension TaskListInteractor {
    func getTodosUrl() -> String {
        return APIConstants.baseUrl + APIConstants.todosEndpoint
    }
    
    func getSortedTasks(_ tasks: [Task]) -> [Task] {
        return tasks.sorted { $0.id > $1.id }
    }
}
