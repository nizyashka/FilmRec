import UIKit

extension Data {
    func toColor() -> UIColor? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self)
    }
}
