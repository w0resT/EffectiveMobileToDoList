import UIKit

class TaskDetailsViewController: UIViewController {
    
    // MARK: - Public Properties
    var presenter: TaskDetailsPresenterProtocol?
    
    // MARK: - Private Properties
    private var task: TaskViewModel?
    
    // MARK: - UI Elements
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Title"
        textView.textColor = AppColors.whiteOpacity
        textView.font = AppFonts.title
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.accessibilityIdentifier = "taskDetailsTitleTextView"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.whiteOpacity
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Description"
        textView.textColor = AppColors.whiteOpacity
        textView.font = AppFonts.description
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.accessibilityIdentifier = "taskDetailsDescriptionTextView"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Setup UI
private extension TaskDetailsViewController {
    func setupUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = AppColors.black
        
        setupHeaderStackView()
        setupDescriptionTextView()
    }
    
    func setupHeaderStackView() {
        if headerStackView.superview == nil {
            view.addSubview(headerStackView)
        }
        
        headerStackView.addArrangedSubview(titleTextView)
        headerStackView.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupDescriptionTextView() {
        if descriptionTextView.superview == nil {
            view.addSubview(descriptionTextView)
        }
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TaskDetailsViewProtocol
extension TaskDetailsViewController: TaskDetailsViewProtocol {
    func showTaskDetails(_ task: TaskViewModel) {
        // TODO: move to private func
        titleTextView.textColor = AppColors.pureWhite
        titleTextView.text = task.title
        dateLabel.text = task.formattedDate
        descriptionTextView.textColor = AppColors.pureWhite
        descriptionTextView.text = task.description
    }
}

// MARK: - UITextViewDelegate
extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Если установлен цвет "AppColors.whiteOpacity", то текущий текст это плейсхолдер
        if textView.textColor == AppColors.whiteOpacity {
            textView.text = ""
            textView.textColor = AppColors.pureWhite
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView.accessibilityIdentifier {
        case "taskDetailsTitleTextView":
            presenter?.didChangeTitle(with: textView.text)
        case "taskDetailsDescriptionTextView":
            presenter?.didChangeDescription(with: textView.text)
        default:
            break
        }
        
        // Placeholder
        if textView.text.isEmpty || textView.text == "" {
            textView.text = textView.accessibilityIdentifier == "taskDetailsTitleTextView" ? "Title" : "Description"
            textView.textColor = AppColors.whiteOpacity
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Save char by char?
    }
}
