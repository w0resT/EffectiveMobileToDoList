import Foundation

class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Public Propeties
    weak var presenter: TaskListInteractorOutputProtocol?
    
    // MARK: - Private Properties
    // storage
    // network
    
    // MARK: - TaskListInteractorProtocol
    func fetchTasks() {
        var tasks: [Task] = []
        
        // networkManager...
        
        // TODO: REMOVE TEMP
        tasks.append(Task(id: 1, title: "Почитать книгу", description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", dateCreated: Date.now, isCompleted: false))
        tasks.append(Task(id: 2, title: "Почитать книгу 23", description: "Составить список необходимых.", dateCreated: Date.now, isCompleted: true))
        tasks.append(Task(id: 3, title: "Почитать книгу и еще что-то, просто большой теееееекст заголовок ааааааааааааааааааааааааааааааа", description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", dateCreated: Date.now, isCompleted: false))
        tasks.append(Task(id: 4, title: "Почитать книгу 23", description: "Составить список необходимых.", dateCreated: Date.now, isCompleted: true))
        tasks.append(Task(id: 5, title: "Почитать книгу", description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", dateCreated: Date.now, isCompleted: false))
        tasks.append(Task(id: 6, title: "Почитать книгу 23", description: "Составить список необходимых.", dateCreated: Date.now, isCompleted: true))
        
        presenter?.didFetchTasks(tasks)
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
