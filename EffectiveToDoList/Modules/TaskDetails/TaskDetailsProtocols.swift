import Foundation

// MARK: - View Protocol
protocol TaskDetailsViewProtocol: AnyObject {
    func showTaskDetails(_ task: TaskViewModel)
}

// MARK: - Interactor Protocols
protocol TaskDetailsInteractorProtocol: AnyObject {

}

protocol TaskDetailsInteractorOutputProtocol: AnyObject {

}

// MARK: - Presenter Protocol
protocol TaskDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeTitle(with text: String)
    func didChangeDescription(with description: String)
}

// MARK: - Router Protocol
protocol TaskDetailsRouterProtocol: AnyObject {

}
