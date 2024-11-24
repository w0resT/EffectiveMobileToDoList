import Foundation

class TaskDetailsPresenter: TaskDetailsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: TaskDetailsViewProtocol?
    weak var delegate: TaskDetailsDelegate?
    var router: TaskDetailsRouterProtocol?
    var interactor: TaskDetailsInteractorProtocol?
    
    // MARK: - TaskDetailsPresenterProtocol
    func didChangeTitle(with text: String) {
        view?.updateTitle(with: text)
    }
    
    func didChangeDescription(with description: String) {
        view?.updateDescription(with: description)
    }
    
    func didTapBackButton(task: TaskViewModel) {
        var entityTask = Task(taskViewModel: task)
        entityTask.title = entityTask.title.trimmingCharacters(in: .whitespacesAndNewlines)
        entityTask.description = entityTask.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        interactor?.createOrUpdateTask(entityTask)
    }
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
    func didFetchTask(_ task: Task) {
        let taskViewModel = TaskViewModel(task: task)
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

