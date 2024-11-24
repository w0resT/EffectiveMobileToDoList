import UIKit

final class TaskDetailsConfigurator {
    static func configure(with task: Task? = nil) -> UIViewController {
        let view = TaskDetailsViewController()
        let interactor = TaskDetailsInteractor()
        let presenter = TaskDetailsPresenter()
        let router = TaskDetailsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = view
        
        interactor.presenter?.didFetchTask(task ?? Task())
        
        return view
    }
}
