import UIKit

// TODO: String, constants

class TaskListViewController: UIViewController {
    // MARK: - Public Properties
    var presenter: TaskListPresenterProtocol?
    
    // MARK: - UI Elements
    private lazy var viewManager: TaskListViewManager = {
        let manager = TaskListViewManager()
        manager.controller = self
        return manager
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupActions()
        viewManager.setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Actions
private extension TaskListViewController {
    @objc func didTapAddButton() {
        presenter?.didCreateTask()
    }
}

// MARK: - TaskListViewProtocol
extension TaskListViewController: TaskListViewProtocol {
    func showTasks(_ tasks: [TaskListViewModel]) {
        presenter?.updateTaskCount(tasks.count)
        viewManager.showTasks(tasks)
    }
    
    func showAlert(_ message: String) {
        viewManager.showAlert(message)
    }
    
    func updateTaskCount(with text: String) {
        viewManager.countLabel.text = text
    }
    
    func showActivityIndicator() {
        viewManager.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        viewManager.activityIndicator.stopAnimating()
    }
}

// MARK: -  TaskListTableViewControllerDelegate
extension TaskListViewController: TaskListTableViewControllerDelegate {
    func didShareTask(_ task: TaskListViewModel) {
        presenter?.didShareTask(task)
    }
    
    func didSelectTask(_ task: TaskListViewModel) {
        presenter?.didSelectTask(task)
    }
    
    func didDeleteTask(_ task: TaskListViewModel) {
        presenter?.didDeleteTask(task)
    }
    
    func didCompleteTask(_ task: TaskListViewModel) {
        presenter?.didCompleteTask(task)
    }
}

// MARK: - UISearchResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        presenter?.didUpdateSearchResults(searchText)
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupDelegates() {
        viewManager.searchController.searchResultsUpdater = self
        viewManager.tableViewController.delegate = self
    }
    
    func setupActions() {
        viewManager.addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
}
