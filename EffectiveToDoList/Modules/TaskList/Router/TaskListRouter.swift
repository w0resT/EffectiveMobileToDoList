import UIKit

class TaskListRouter: TaskListRouterProtocol {
    
    // MARK: - Properties
    weak var view: UIViewController?
    
    // MARK: - TaskListRouterProtocol
    func navigateToTaskDetails(with task: Task) {
        let taskDetailsVC = TaskDetailsConfigurator.configure(with: task)
        
        // Устанавливаем делегат для TaskDetails
        let taskDetailsPresenter = (taskDetailsVC as? TaskDetailsViewProtocol)?.presenter
        let taskListPresenter = (view as? TaskListViewProtocol)?.presenter
        taskDetailsPresenter?.delegate = taskListPresenter
        
        view?.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    func navigateToAddTask() {
        let taskDetailsVC = TaskDetailsConfigurator.configure()
        
        // Устанавливаем делегат для TaskDetails
        let taskDetailsPresenter = (taskDetailsVC as? TaskDetailsViewProtocol)?.presenter
        let taskListPresenter = (view as? TaskListViewProtocol)?.presenter
        taskDetailsPresenter?.delegate = taskListPresenter
        
        view?.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
}
