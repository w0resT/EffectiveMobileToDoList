import Foundation

class TaskListPresenter: TaskListPresenterProtocol {

    // MARK: - Properties
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    weak var view: TaskListViewProtocol?
    
    private var tasks: [TaskViewModel] = []
    private var filteredTasks: [TaskViewModel] = []
    
    // MARK: - TaskListPresenterProtocol
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func didSelectTask(task: TaskViewModel) {
        let taskEntity = Task(taskViewModel: task)
        router?.navigateToTaskDetails(with: taskEntity)
    }
    
    func didTapAddTask() {
        router?.navigateToAddTask()
    }
    
    func didTapShare(task: TaskViewModel) {
        // share
    }
    
    func didTapDelete(task: TaskViewModel) {
        let taskEntity = Task(taskViewModel: task)
        interactor?.removeTask(taskEntity)
    }
    
    func didTapCompleted(task: TaskViewModel) {
        let taskEntity = Task(taskViewModel: task)
        interactor?.updateTaskStatus(taskEntity)
        
        // TODO: interactor -> storage upd -> presenter -> ...
        if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[taskIndex].isCompleted.toggle()
            // TODO: update row
            view?.showTasks(tasks)
        }
    }
    
    func didUpdateSearchResults(for text: String) {
        filteredTasks = text.isEmpty ? tasks : tasks.filter { $0.title.lowercased().contains(text.lowercased()) }
        view?.showTasks(filteredTasks)
    }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(_ tasks: [Task]) {
        self.tasks = tasks.map{ TaskViewModel(task: $0)}
        view?.showTasks(self.tasks)
    }
    
    func didFailToFetchTasks(_ error: String) {
        // show alert
    }
    
    func didAddTask(_ task: Task) {
        // update row/table
    }
    
    func didFailToAddTask(_ error: String) {
        // show alert
    }
    
    func didRemoveTask(_ task: Task) {
        // update row/table
    }
    
    func didFailToRemoveTask(_ error: String) {
        // show alert
    }
    
    func didUpdateTaskStatus( _task: Task) {
        // update row/table
    }
    
    func didFailToUpdateTaskStatus(_ error: String) {
        // show alert
    }
}
