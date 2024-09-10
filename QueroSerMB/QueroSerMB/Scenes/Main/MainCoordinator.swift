import UIKit

protocol MainCoordinating: AnyObject {
    func openSomething()
}

final class MainCoordinator {
    weak var viewController: UIViewController?

}

// MARK: - MainCoordinating
extension MainCoordinator: MainCoordinating {
    func openSomething() {
        // template
    }
}
