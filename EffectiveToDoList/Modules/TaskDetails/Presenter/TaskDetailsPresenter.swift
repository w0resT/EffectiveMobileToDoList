import Foundation

class TaskDetailsPresenter: TaskDetailsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: TaskDetailsViewProtocol?
    var router: TaskDetailsRouterProtocol?
    var interactor: TaskDetailsInteractorProtocol?
    var task: Task?
    
    // MARK: - TaskDetailsPresenterProtocol
    func viewDidLoad() {
        if let task = task {
            let taskViewModel = TaskViewModel(task: task)
            view?.showTaskDetails(taskViewModel)
        }
    }
    
    func didChangeTitle(with text: String) {
        
    }
    
    func didChangeDescription(with description: String) {
        
    }
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
    
}

