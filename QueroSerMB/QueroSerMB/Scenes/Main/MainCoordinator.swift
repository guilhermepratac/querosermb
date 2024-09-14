import UIKit

protocol MainCoordinating: AnyObject {
    func openExchangeDetail(with id: String)
}

final class MainCoordinator {
    weak var viewController: UIViewController?

}

// MARK: - MainCoordinating
extension MainCoordinator: MainCoordinating {
    func openExchangeDetail(with id: String) {
        let controller = DetailFactory.make(exchangeID: id)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
