import Foundation

// MARK: - Delegate
protocol TaskDetailsDelegate: AnyObject {
    func didUpdateTask(_ task: Task)
}

// MARK: - View Protocol
protocol TaskDetailsViewProtocol: AnyObject {
    var presenter: TaskDetailsPresenterProtocol? { get }
    
    func showTaskDetails(_ task: TaskListViewModel)
    func updateTitle(with text: String)
    func updateDescription(with text: String)
}

// MARK: - Interactor Protocols
protocol TaskDetailsInteractorProtocol: AnyObject {
    func createOrUpdateTask(_ task: Task)
}

protocol TaskDetailsInteractorOutputProtocol: AnyObject {
    func didFetchTask(_ task: Task)
    func navigateBack()
    func delegateAndNavigateBack(_ task: Task)
}

// MARK: - Presenter Protocol
protocol TaskDetailsPresenterProtocol: AnyObject {
    var delegate: TaskDetailsDelegate? { get set }
    
    func didChangeTitle(with text: String)
    func didChangeDescription(with description: String)
    func didTapBackButton(task: TaskListViewModel)
}

// MARK: - Router Protocol
protocol TaskDetailsRouterProtocol: AnyObject {
    func navigateBack()
}
