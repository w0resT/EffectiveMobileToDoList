import UIKit

// TODO: String, constants

class TaskListViewController: UIViewController {
    // MARK: - Public Properties
    var presenter: TaskListPresenterProtocol?
    
    // MARK: - Private Properties
    private var tasks: [TaskViewModel] = []
    
    // MARK: - UI Elements
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        return controller
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = AppColors.stroke
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskViewCell.self, forCellReuseIdentifier: "taskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular11
        label.textColor = AppColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setBackgroundImage(AppIcons.create, for: .normal)
        button.tintColor = AppColors.yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var spacerView: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Actions
private extension TaskListViewController {
    @objc func didTapAddButton() {
        presenter?.didTapAddTask()
    }
}

// MARK: - TaskListViewProtocol
extension TaskListViewController: TaskListViewProtocol {
    func showTasks(_ tasks: [TaskViewModel]) {
        self.tasks = tasks
        self.countLabel.text = "\(tasks.count) задач"
        
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", 
                                                       for: indexPath) as? TaskViewCell else {
            return UITableViewCell()
        }
        
        let currentTask = tasks[indexPath.row]
        cell.configure(with: currentTask)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        presenter?.didSelectTask(task: selectedTask)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedTask = tasks[indexPath.row]
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") {_,_,_ in
            self.presenter?.didTapDelete(task: selectedTask)
        }
        
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedTask = tasks[indexPath.row]
        let actionComplete = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.presenter?.didTapCompleted(task: selectedTask)
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

// MARK: - UISearchResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter?.didUpdateSearchResults(for: searchText)
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupUI() {
        setupSelfView()
        setupTableView()
        setupFooterView()
        setupActivityIndicator()
    }
    
    func setupSelfView() {
        self.title = "Задачи"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = AppColors.yellow
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.backButtonTitle = "Назад"
    }
    
    func setupTableView() {
        if tableView.superview == nil {
            view.addSubview(tableView)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupFooterView() {
        if footerView.superview == nil {
            view.addSubview(footerView)
        }
        
        footerView.addSubview(footerStackView)
        
        footerStackView.addArrangedSubview(spacerView)
        footerStackView.addArrangedSubview(countLabel)
        footerStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            footerStackView.topAnchor.constraint(equalTo: footerView.topAnchor),
            footerStackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            footerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            spacerView.heightAnchor.constraint(equalToConstant: 30),
            spacerView.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupActivityIndicator() {
        if activityIndicator.superview == nil {
            view.addSubview(activityIndicator)
        }
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Helpers
private extension TaskListViewController {
    
    // TODO: move to ViewManager
    func createContextMenu(for task: TaskViewModel) -> UIMenu {
        let inspectAction = UIAction(title: "Редактировать", 
                                     image: AppIcons.edit?.withTintColor(AppColors.pureWhite)) { _ in
                self.presenter?.didSelectTask(task: task)
        }
        
        let duplicateAction = UIAction(title: "Поделиться", 
                                       image: AppIcons.export?.withTintColor(AppColors.pureWhite)) { _ in
                self.presenter?.didTapShare(task: task)
        }
        
        let deleteAction = UIAction(title: "Удалить", 
                                    image: AppIcons.trash, attributes: .destructive) { _ in
                self.presenter?.didTapDelete(task: task)
        }
        
        return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
    }
}
