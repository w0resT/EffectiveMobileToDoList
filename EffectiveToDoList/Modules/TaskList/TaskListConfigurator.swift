import UIKit

final class TaskListConfigurator {
    static func configure() -> UIViewController {
        let networkService = NetworkService()
        let networkManager = NetworkManager(networkService: networkService)
        let storageManager = StorageManager()
        
        let view = TaskListViewController()
        let interactor = TaskListInteractor(networkManager: networkManager, storageManager: storageManager)
        let presenter = TaskListPresenter()
        let router = TaskListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
}
