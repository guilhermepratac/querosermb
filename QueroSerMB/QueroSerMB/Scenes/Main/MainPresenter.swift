import UIKit

protocol MainPresenting: AnyObject {
    func displaySomething()
    func didNextStep()
}

final class MainPresenter {
    private let coordinator: MainCoordinating
    weak var viewController: MainDisplaying?

    init(coordinator: MainCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - MainPresenting
extension MainPresenter: MainPresenting {
    func displaySomething() {
        viewController?.displayExchanges(exchanges: [createModel(), createModel(), createModel()])
    }
    
    func didNextStep() {
        coordinator.openSomething()
    }
}

// MARK: Helpers
extension MainPresenter {
    private func createModel() -> ExchangeCellModel {
        return ExchangeCellModel(
            icon: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_512/5fbfbd742fb64c67a3963ebd7265f9f3.png",
            name: "Bitcoin",
            exchange: "ID: Bitcoin",
            price: "$16"
        )
    }
}
