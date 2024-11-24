import Foundation

class TaskListPresenter: TaskListPresenterProtocol {

    // MARK: - Properties
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    weak var view: TaskListViewProtocol?
    
    // MARK: - TaskDetailsDelegate
    func didUpdateTask(_ task: Task) {
        interactor?.createOrUpdateTask(task)
    }
    
    // MARK: - TaskListPresenterProtocol
    func viewDidLoad() {
        // TODO: Update tasks in storage after fetching
        view?.showActivityIndicator()
//        interactor?.fetchTasksNetwork()
        interactor?.fetchTasks()
    }
    
    func didSelectTask(task: TaskViewModel) {
        let taskEntity = Task(taskViewModel: task)
        router?.navigateToTaskDetails(with: taskEntity)
    }
    
    func didTapAddTask() {
        router?.navigateToAddTask()
    }
    
    func didTapShare(task: TaskViewModel) {}
    
    func didTapDelete(task: TaskViewModel) {
        let taskEntity = Task(taskViewModel: task)
        interactor?.deleteTask(taskEntity)
    }
    
    func didTapCompleted(task: TaskViewModel) {
        let taskEntity = Task(taskViewModel: task)
        interactor?.updateTask(taskEntity)
    }
    
    func didUpdateSearchResults(for text: String) {
        // TODO: interactor -> storage upd -> presenter -> ...
//        filteredTasks = text.isEmpty ? tasks : tasks.filter { $0.title.lowercased().contains(text.lowercased()) }
//        view?.showTasks(filteredTasks)
    }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(_ tasks: [Task]) {
        let tasksViewModel = tasks.map{ TaskViewModel(task: $0)}
        view?.hideActivityIndicator()
        view?.showTasks(tasksViewModel)
    }
    
    func didCreateTask(_ tasks: [Task]) {
        let tasksViewModel = tasks.map{ TaskViewModel(task: $0)}
        view?.showTasks(tasksViewModel)
    }
    
    func didDeleteTask(_ tasks: [Task]) {
        let tasksViewModel = tasks.map{ TaskViewModel(task: $0)}
        view?.showTasks(tasksViewModel)
    }
    
    func didUpdateTask(_ tasks: [Task]) {
        let tasksViewModel = tasks.map{ TaskViewModel(task: $0)}
        view?.showTasks(tasksViewModel)
    }
    
    func didCreateOrUpdateTask(_ tasks: [Task]) {
        let tasksViewModel = tasks.map{ TaskViewModel(task: $0)}
        view?.showTasks(tasksViewModel)
    }
    
    func didFailToFetchTasks(_ error: String) {
        print("didFailToFetchTasks: \(error)")
        // view show alert with msg = error
        view?.hideActivityIndicator()
    }
    
    func didFailToCreateTask(_ error: String) {
        print("didFailToCreateTask: \(error)")
        // view show alert with msg = error
    }
    
    func didFailToDeleteTask(_ error: String) {
        print("didFailToDeleteTask: \(error)")
        // view show alert with msg = error
    }
    
    func didFailToUpdateTask(_ error: String) {
        print("didFailToUpdateTask: \(error)")
        // view show alert with msg = error
    }
    
    func didFailToCreateOrUpdateTask(_ error: String) {
        print("didFailToCreateOrUpdateTask: \(error)")
        // view show alert with msg = error
    }
}
