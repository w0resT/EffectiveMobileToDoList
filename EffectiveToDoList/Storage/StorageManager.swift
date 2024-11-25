import Foundation

protocol StorageManagerProtocol {
    func hasTasks(completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    func createTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void)
    func updateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void)
    func deleteTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void)
    func createOrUpdateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void)
    func createOrUpdateTasks(_ tasks: [Task], completion: @escaping (Result<[Task], Error>) -> Void)
    func fetchFilteredTasks(_ text: String, completion: @escaping (Result<[Task], Error>) -> Void)
}

class StorageManager: StorageManagerProtocol {

    // MARK: - Properties
    private var coreDataManager: CoreDataManager
    
    // MARK: - Initializers
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - StorageManagerProtocol
    func hasTasks(completion: @escaping (Result<Bool, Error>) -> Void) {
        coreDataManager.hasTasks { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func createTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        coreDataManager.createTask(task) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        coreDataManager.fetchTasks { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        coreDataManager.updateTask(task) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func deleteTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        coreDataManager.deleteTask(task) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func createOrUpdateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        coreDataManager.createOrUpdateTask(task) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func createOrUpdateTasks(_ tasks: [Task], completion: @escaping (Result<[Task], Error>) -> Void) {
        coreDataManager.createOrUpdateTasks(tasks) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchFilteredTasks(_ text: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        coreDataManager.fetchFilteredTasks(text) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
