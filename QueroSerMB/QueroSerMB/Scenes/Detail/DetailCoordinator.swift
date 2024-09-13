import UIKit

protocol DetailCoordinating: AnyObject {
    func openSomething()
}

final class DetailCoordinator {
    weak var viewController: UIViewController?
}

// MARK: - DetailCoordinating
extension DetailCoordinator: DetailCoordinating {
    func openSomething() {
        // template
    }
}
