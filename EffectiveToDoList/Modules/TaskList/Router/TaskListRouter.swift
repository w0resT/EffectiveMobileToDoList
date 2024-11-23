import UIKit

class TaskListRouter: TaskListRouterProtocol {
    
    // MARK: - Properties
    weak var view: UIViewController?
    
    // MARK: - TaskListRouterProtocol
    func navigateToTaskDetails(with task: Task) {
        let taskDetailsVC = TaskDetailsConfigurator.configure(with: task)
        view?.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    func navigateToAddTask() {
        let taskDetailsVC = TaskDetailsConfigurator.configure()
        view?.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
}
