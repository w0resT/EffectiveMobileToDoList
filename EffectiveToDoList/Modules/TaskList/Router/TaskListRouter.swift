import UIKit

class TaskListRouter: TaskListRouterProtocol {
    
    // MARK: - Properties
    weak var view: UIViewController?
    
    func navigateToTaskDetails(with task: Task) {
        // configure + navController push
    }
    
    func navigateToAddTask() {
        // configure + navController push
    }
}
