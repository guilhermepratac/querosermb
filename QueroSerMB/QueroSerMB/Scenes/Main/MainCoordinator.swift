import UIKit

protocol MainCoordinating: AnyObject {
    func openExchangeDetail(with exchange: ExchangeDetail)
}

final class MainCoordinator {
    weak var viewController: UIViewController?

}

// MARK: - MainCoordinating
extension MainCoordinator: MainCoordinating {
    func openExchangeDetail(with exchange: ExchangeDetail) {
        let controller = DetailFactory.make(exchange: exchange)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
