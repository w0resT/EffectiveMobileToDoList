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
        interactor?.loadTasksOnAppLaunch()
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
        interactor?.fetchFilteredTasks(text)
    }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasksNetwork(_ tasks: [Task]) {
        interactor?.createOrUpdateTasks(tasks)
    }
    
    func didFetchTasks(_ tasks: [Task]) {
        view?.hideActivityIndicator()
        transformAndShowTasks(tasks)
    }
    
    func didCreateTask(_ tasks: [Task]) {
        transformAndShowTasks(tasks)
    }
    
    func didDeleteTask(_ tasks: [Task]) {
        transformAndShowTasks(tasks)
    }
    
    func didUpdateTask(_ tasks: [Task]) {
        transformAndShowTasks(tasks)
    }
    
    func didCreateOrUpdateTask(_ tasks: [Task]) {
        transformAndShowTasks(tasks)
    }
    
    func didCreateOrUpdateTasks(_ tasks: [Task]) {
        view?.hideActivityIndicator()
        transformAndShowTasks(tasks)
    }
    
    func didFetchFilteredTasks(_ tasks: [Task]) {
        transformAndShowTasks(tasks)
    }
    
    func didFailToLoadTasksOnAppLaunch(_ error: String) {
        print("didFailToLoadTasksOnAppLaunch: \(error)")
        // view show alert with msg = error
        view?.hideActivityIndicator()
    }
    
    func didFailToFetchTasksNetwork(_ error: String) {
        print("didFailToFetchTasksNetwork: \(error)")
        // view show alert with msg = error
        view?.hideActivityIndicator()
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
    
    func didFailToCreateOrUpdateTasks(_ error: String) {
        print("didFailToCreateOrUpdateTasks: \(error)")
        // view show alert with msg = error
        view?.hideActivityIndicator()
    }
    
    func didFailToFetchFilteredTasks(_ error: String) {
        print("didFailToFetchFilteredTasks: \(error)")
        // view show alert with msg = error
    }
}

private extension TaskListPresenter {
    func transformAndShowTasks(_ tasks: [Task]) {
        let tasksViewModel = tasks.map{ TaskViewModel(task: $0)}
        view?.showTasks(tasksViewModel)
    }
}
