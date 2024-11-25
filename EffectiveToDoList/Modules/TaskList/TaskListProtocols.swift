import Foundation

// MARK: - View Protocol
protocol TaskListViewProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get }
    
    func showTasks(_ tasks: [TaskViewModel])
    func showAlert(with message: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

// MARK: - Interactor Protocols
protocol TaskListInteractorProtocol: AnyObject {
    func loadTasksOnAppLaunch()
    func fetchTasksNetwork()
    func fetchTasks()
    func createTask(_ task: Task)
    func deleteTask(_ task: Task)
    func updateTask(_ task: Task)
    func createOrUpdateTask(_ task: Task)
    func createOrUpdateTasks(_ tasks: [Task])
    func fetchFilteredTasks(_ text: String)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasksNetwork(_ tasks: [Task])
    func didFetchTasks(_ tasks: [Task])
    func didCreateTask(_ tasks: [Task])
    func didDeleteTask(_ tasks: [Task])
    func didUpdateTask(_ tasks: [Task])
    func didCreateOrUpdateTask(_ tasks: [Task])
    func didCreateOrUpdateTasks(_ tasks: [Task])
    func didFetchFilteredTasks(_ tasks: [Task])
    
    func didFailToLoadTasksOnAppLaunch(_ error: String)
    func didFailToFetchTasksNetwork(_ error: String)
    func didFailToFetchTasks(_ error: String)
    func didFailToCreateTask(_ error: String)
    func didFailToDeleteTask(_ error: String)
    func didFailToUpdateTask(_ error: String)
    func didFailToCreateOrUpdateTask(_ error: String)
    func didFailToCreateOrUpdateTasks(_ error: String)
    func didFailToFetchFilteredTasks(_ error: String)
}

// MARK: - Presenter Protocol
protocol TaskListPresenterProtocol: TaskDetailsDelegate, AnyObject {
    func viewDidLoad()
    func didSelectTask(task: TaskViewModel)
    func didTapAddTask()
    func didTapShare(task: TaskViewModel)
    func didTapDelete(task: TaskViewModel)
    func didTapCompleted(task: TaskViewModel)
    func didUpdateSearchResults(for text: String)
}

// MARK: - Router Protocol
protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetails(with task: Task)
    func navigateToAddTask()
}
