import UIKit

enum DetailFactory {
    static func make(exchangeID: String) -> UIViewController {
        let coreNetwork = CoreNetwork()

        let service = DetailService(coreService: coreNetwork)
        let coordinator = DetailCoordinator()
        let presenter = DetailPresenter(coordinator: coordinator)
        let interactor = DetailInteractor(service: service, presenter: presenter, exchangeID: exchangeID)
        let viewController = DetailViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
