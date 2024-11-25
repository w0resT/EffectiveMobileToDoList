import UIKit

class TaskViewCell: UITableViewCell {
    // MARK: - UI Elements
    private lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = AppIcons.unselected
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.button
        label.textColor = AppColors.pureWhite
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.pureWhite
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.whiteOpacity
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with task: TaskListCellViewModel) {
        iconImageView.image = task.icon
        titleLabel.attributedText = task.title
        titleLabel.textColor = task.textColor
        descriptionLabel.text = task.description
        descriptionLabel.textColor = task.textColor
        dateLabel.text = task.date
    }
}

// MARK: - Setup UI
private extension TaskViewCell {
    func setupUI() {
        self.backgroundColor = .clear
        
        setupIconImageView()
        setupVStackView()
    }
    
    func setupIconImageView() {
        if iconImageView.superview == nil {
            contentView.addSubview(iconImageView)
        }
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setupVStackView() {
        if vStackView.superview == nil {
            contentView.addSubview(vStackView)
            
            vStackView.addArrangedSubview(titleLabel)
            vStackView.addArrangedSubview(descriptionLabel)
            vStackView.addArrangedSubview(dateLabel)
        }
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            vStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
