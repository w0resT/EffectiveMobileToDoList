import Foundation

// MARK: - View Protocol
protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [TaskViewModel])
    
}

// MARK: - Interactor Protocols
protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func addTask(_ task: Task)
    func removeTask(_ task: Task)
    func updateTaskStatus(_ task: Task)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
    func didFailToFetchTasks(_ error: String)
    func didAddTask(_ task: Task)
    func didFailToAddTask(_ error: String)
    func didRemoveTask(_ task: Task)
    func didFailToRemoveTask(_ error: String)
    func didUpdateTaskStatus( _task: Task)
    func didFailToUpdateTaskStatus(_ error: String)
}

// MARK: - Presenter Protocol
protocol TaskListPresenterProtocol: AnyObject {
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
