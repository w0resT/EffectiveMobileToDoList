import Foundation

class TaskListPresenter: TaskListPresenterProtocol {

    // MARK: - Properties
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    weak var view: TaskListViewProtocol?
    
    // MARK: - Initializers
    init(interactor: TaskListInteractorProtocol? = nil, router: TaskListRouterProtocol? = nil, view: TaskListViewProtocol? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    // MARK: - TaskDetailsDelegate
    func didUpdateTask(_ task: Task) {
        interactor?.createOrUpdateTask(task)
    }
    
    // MARK: - TaskListPresenterProtocol
    func viewDidLoad() {
        view?.showActivityIndicator()
        interactor?.loadTasksOnAppLaunch()
    }
    
    func updateTaskCount(_ count: Int) {
        view?.updateTaskCount(with: "\(count) задач")
    }
    
    func didSelectTask(_ task: TaskListViewModel) {
        let taskEntity = Task(taskViewModel: task)
        router?.navigateToTaskDetails(with: taskEntity)
    }
    
    func didCreateTask() {
        router?.navigateToAddTask()
    }
    
    func didShareTask(_ task: TaskListViewModel) {}
    
    func didDeleteTask(_ task: TaskListViewModel) {
        let taskEntity = Task(taskViewModel: task)
        interactor?.deleteTask(taskEntity)
    }
    
    func didCompleteTask(_ task: TaskListViewModel) {
        let taskEntity = Task(taskViewModel: task)
        interactor?.updateTask(taskEntity)
    }
    
    func didUpdateSearchResults(_ text: String?) {
        guard let text = text else { return }
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
        view?.hideActivityIndicator()
        view?.showAlert(error)
    }
    
    func didFailToFetchTasksNetwork(_ error: String) {
        view?.hideActivityIndicator()
        view?.showAlert(error)
    }
    
    func didFailToFetchTasks(_ error: String) {
        view?.hideActivityIndicator()
        view?.showAlert(error)
    }
    
    func didFailToCreateTask(_ error: String) {
        view?.showAlert(error)
    }
    
    func didFailToDeleteTask(_ error: String) {
        view?.showAlert(error)
    }
    
    func didFailToUpdateTask(_ error: String) {
        view?.showAlert(error)
    }
    
    func didFailToCreateOrUpdateTask(_ error: String) {
        view?.showAlert(error)
    }
    
    func didFailToCreateOrUpdateTasks(_ error: String) {
        view?.hideActivityIndicator()
        view?.showAlert(error)
    }
    
    func didFailToFetchFilteredTasks(_ error: String) {
        view?.showAlert(error)
    }
}

private extension TaskListPresenter {
    func transformAndShowTasks(_ tasks: [Task]) {
        let tasksViewModel = tasks.map{ TaskListViewModel(task: $0)}
        view?.showTasks(tasksViewModel)
    }
}
