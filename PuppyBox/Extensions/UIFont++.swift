
import UIKit

extension UIFont {
    static func plusJakarta(size: CGFloat, weight: FontWeight = .regular) -> UIFont? {
        let name: String
        switch weight {
        case .bold: name = "PlusJakartaSans-Bold"
        case .semibold: name = "PlusJakartaSans-SemiBold"
        case .medium: name = "PlusJakartaSans-Medium"
        default: name = "PlusJakartaSans-Regular"
        }
        return UIFont(name: name, size: size)
    }

    enum FontWeight {
        case regular, medium, semibold, bold
    }
}

