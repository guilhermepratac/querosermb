import UIKit

enum MainFactory {
    static func make() -> UIViewController {
        let service = MainService()
        let coordinator = MainCoordinator()
        let presenter = MainPresenter(coordinator: coordinator)
        let interactor = MainInteractor(service: service, presenter: presenter)
        let viewController = MainViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
