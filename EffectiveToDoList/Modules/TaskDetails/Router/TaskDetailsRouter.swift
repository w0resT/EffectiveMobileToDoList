import UIKit

class TaskDetailsRouter: TaskDetailsRouterProtocol {
    
    // MARK: - Properties
    weak var view: UIViewController?
    
    // MARK: - TaskDetailsRouterProtocol
    func navigateBack() {
        view?.navigationController?.popViewController(animated: true)
    }
}
