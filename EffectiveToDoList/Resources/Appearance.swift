import UIKit

struct AppColors {
    static let black = UIColor.black
    static let pureWhite = UIColor.white
    static let white = UIColor(hex: "#F4F4F4")
    static let whiteOpacity = UIColor(hex: "#80F4F4F4") // 0x80 - 50% Opacity
    static let yellow = UIColor(hex: "#FED702")
    static let gray = UIColor(hex: "#272729")
    static let red = UIColor(hex: "#D70015")
    static let stroke = UIColor(hex: "#4E555E")
}

struct AppFonts {
    static let regular = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let regular11 = UIFont.systemFont(ofSize: 11, weight: .regular)
    static let button = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let title = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let description = UIFont.systemFont(ofSize: 16, weight: .regular)
}

struct AppIcons {
    static let create = UIImage(systemName: "square.and.pencil")
    static let checkmark = UIImage(systemName: "checkmark.circle")
    static let trash = UIImage(systemName: "trash")
    static let edit = UIImage(named: "iconEdit")
    static let export = UIImage(named: "iconExport")
    static let selected = UIImage(named: "iconSelected")
    static let unselected = UIImage(named: "iconUnselected")
}
