import UIKit

struct TaskListCellViewModel {
    let title: NSAttributedString
    let description: String?
    let date: String
    let icon: UIImage?
    let textColor: UIColor
}

extension TaskListCellViewModel {
    init(task: TaskListViewModel) {
        let isCompleted = task.isCompleted
        self.icon = isCompleted ? AppIcons.selected : AppIcons.unselected
        self.textColor = isCompleted ? AppColors.whiteOpacity : AppColors.pureWhite
        self.title = task.title.strikeThrough(isCompleted)
        self.description = task.description
        self.date = task.formattedDate
    }
}
