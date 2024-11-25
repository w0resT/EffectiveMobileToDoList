import UIKit

final class TaskListViewManager {
    
    // MARK: - Public Propeties
    weak var controller: UIViewController!
    
    // MARK: - UI Elements
    lazy var tableViewController: TaskListTableViewController = {
        let controller = TaskListTableViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var footerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular11
        label.textColor = AppColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setBackgroundImage(AppIcons.create, for: .normal)
        button.tintColor = AppColors.yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var spacerView: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController()
        return controller
    }()
    
    lazy var alertController: UIAlertController = {
        let alertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        return alertController
    }()
    
    // MARK: - Public Methods
    func setupUI() {
        setupSelfView()
        setupTableView()
        setupFooterView()
        setupActivityIndicator()
    }
    
    func showTasks(_ tasks: [TaskListViewModel]) {
        tableViewController.updateTasks(tasks)
    }
    
    func showAlert(_ message: String) {
        alertController.message = message
        controller.present(alertController, animated: true)
    }
}

// MARK: - Setup UI
private extension TaskListViewManager {
    func setupSelfView() {
        controller.title = "Задачи"
        controller.navigationController?.navigationBar.prefersLargeTitles = true
        controller.navigationController?.navigationBar.tintColor = AppColors.yellow
        controller.navigationItem.searchController = searchController
        controller.navigationItem.hidesSearchBarWhenScrolling = false
        controller.navigationItem.backButtonTitle = "Назад"
    }
    
    func setupTableView() {
        if tableViewController.view.superview == nil {
            controller.addChild(tableViewController)
            controller.view.addSubview(tableViewController.view)
            tableViewController.didMove(toParent: controller)
        }
        
        NSLayoutConstraint.activate([
            tableViewController.view.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
            tableViewController.view.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            tableViewController.view.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
        ])
    }
    
    func setupFooterView() {
        if footerView.superview == nil {
            controller.view.addSubview(footerView)
        }
        
        footerView.addSubview(footerStackView)
        
        footerStackView.addArrangedSubview(spacerView)
        footerStackView.addArrangedSubview(countLabel)
        footerStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: tableViewController.view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            footerStackView.topAnchor.constraint(equalTo: footerView.topAnchor),
            footerStackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            footerStackView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
            
            spacerView.heightAnchor.constraint(equalToConstant: 30),
            spacerView.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupActivityIndicator() {
        if activityIndicator.superview == nil {
            controller.view.addSubview(activityIndicator)
        }
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor)
        ])
    }
}
