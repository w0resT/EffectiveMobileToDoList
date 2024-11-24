import UIKit

extension String {
    func strikeThrough(_ isStrikeThrough: Bool) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any]
        if isStrikeThrough {
            attributes = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        } else {
            attributes = [:]
        }

        let attributedString = NSAttributedString(string: self, attributes: attributes)
        return attributedString
    }
}
