import UIKit

protocol TaskListTableViewControllerDelegate: AnyObject {
    func didShareTask(_ task: TaskListViewModel)
    func didSelectTask(_ task: TaskListViewModel)
    func didDeleteTask(_ task: TaskListViewModel)
    func didCompleteTask(_ task: TaskListViewModel)
}

class TaskListTableViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: TaskListTableViewControllerDelegate?
    
    // MARK: - Private Properties
    private var tasks: [TaskListViewModel] = []
    private let cellReuseIdentifier: String = "taskCell"
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = AppColors.stroke
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Public Methods
    func updateTasks(_ tasks: [TaskListViewModel]) {
        self.tasks = tasks
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TaskListTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                       for: indexPath) as? TaskViewCell else {
            return UITableViewCell()
        }
        
        let currentTask = tasks[indexPath.row]
        cell.configure(with: TaskListCellViewModel(task: currentTask))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        delegate?.didSelectTask(selectedTask)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedTask = tasks[indexPath.row]
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") {_,_,_ in
            self.delegate?.didDeleteTask(selectedTask)
        }
        
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedTask = tasks[indexPath.row]
        let actionComplete = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.delegate?.didCompleteTask(selectedTask)
        }
        actionComplete.image = AppIcons.checkmark
        
        let actions = UISwipeActionsConfiguration(actions: [actionComplete])
        return actions
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedTask = tasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {_ in
            return self.createContextMenu(for: selectedTask)
        }
    }
}

// MARK: - SetupUI
private extension TaskListTableViewController {
    func setupUI() {
        setupTableView()
    }
    
    func setupTableView() {
        if tableView.superview == nil {
            view.addSubview(tableView)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Helpers
private extension TaskListTableViewController {
    // TODO: move to ViewManager
    func createContextMenu(for task: TaskListViewModel) -> UIMenu {
        let inspectAction = UIAction(title: "Редактировать",
                                     image: AppIcons.edit?.withTintColor(AppColors.pureWhite)) { _ in
            self.delegate?.didSelectTask(task)
        }
        
        let duplicateAction = UIAction(title: "Поделиться",
                                       image: AppIcons.export?.withTintColor(AppColors.pureWhite)) { _ in
            self.delegate?.didShareTask(task)
        }
        
        let deleteAction = UIAction(title: "Удалить",
                                    image: AppIcons.trash, attributes: .destructive) { _ in
            self.delegate?.didDeleteTask(task)
        }
        
        return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
    }
}
