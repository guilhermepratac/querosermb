import UIKit

enum DetailFactory {
    static func make(exchange: ExchangeDetail) -> UIViewController {
        let coreNetwork = CoreNetwork()

        let service = DetailService(coreService: coreNetwork)
        let coordinator = DetailCoordinator()
        let presenter = DetailPresenter(coordinator: coordinator)
        let interactor = DetailInteractor(service: service, presenter: presenter, exchange: exchange)
        let viewController = DetailViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
