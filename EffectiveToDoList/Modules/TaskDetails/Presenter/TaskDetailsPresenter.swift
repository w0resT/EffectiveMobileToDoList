import Foundation

class TaskDetailsPresenter: TaskDetailsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: TaskDetailsViewProtocol?
    weak var delegate: TaskDetailsDelegate?
    var router: TaskDetailsRouterProtocol?
    var interactor: TaskDetailsInteractorProtocol?
    
    // MARK: - Initializers
    init(interactor: TaskDetailsInteractorProtocol? = nil,
         router: TaskDetailsRouterProtocol? = nil,
         view: TaskDetailsViewProtocol? = nil,
         delegate: TaskDetailsDelegate? = nil) {
        self.view = view
        self.delegate = delegate
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: - TaskDetailsPresenterProtocol
    func didChangeTitle(with text: String) {
        view?.updateTitle(with: text)
    }
    
    func didChangeDescription(with description: String) {
        view?.updateDescription(with: description)
    }
    
    func didTapBackButton(task: TaskListViewModel) {
        var entityTask = Task(taskViewModel: task)
        entityTask.title = entityTask.title.trimmingCharacters(in: .whitespacesAndNewlines)
        entityTask.description = entityTask.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        interactor?.saveAndNavigationBack(entityTask)
    }
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
    func didFetchTask(_ task: Task) {
        let taskViewModel = TaskListViewModel(task: task)
        view?.showTaskDetails(taskViewModel)
    }
    
    func navigateBack() {
        router?.navigateBack()
    }
    
    func delegateAndNavigateBack(_ task: Task) {
        delegate?.didUpdateTask(task)
        router?.navigateBack()
    }
}

