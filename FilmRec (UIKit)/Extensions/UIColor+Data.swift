import UIKit

extension UIColor {
    func toData() -> Data? {
        try? NSKeyedArchiver.archivedData(
            withRootObject: self,
            requiringSecureCoding: false
        )
    }
}
