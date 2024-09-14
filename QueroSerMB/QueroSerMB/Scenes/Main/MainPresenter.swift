import UIKit

protocol MainPresenting: AnyObject {
    func presentExchangeList(exchanges: [Exchange], logos: [ExchangeLogo])
    func presentDetail(with id: String)
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
    func presentDetail(with id: String) {
        coordinator.openExchangeDetail(with: id)
    }
    
    func presentExchangeList(exchanges: [Exchange], logos: [ExchangeLogo]) {
        let list = exchanges.map { model in
            let logo = logos.first(where: { $0.exchangeId == model.exchangeId })
            
            return createModel(with: model, and: logo?.url ?? "")
        }
        
        viewController?.displayExchanges(exchanges: list)
    }
}

// MARK: Helpers
extension MainPresenter {
    private func createModel(with exchange: Exchange, and logo: String) -> ExchangeCellModel {
        return ExchangeCellModel(
            icon: logo,
            name: exchange.name ?? " ",
            exchange: exchange.exchangeId,
            price: "\(exchange.dailyVolumeUsd)"
        )
    }
}
