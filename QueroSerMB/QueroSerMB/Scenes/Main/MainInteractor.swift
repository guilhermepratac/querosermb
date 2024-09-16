import Foundation

protocol MainInteracting: AnyObject {
    func load()
    func didTapCell(index: Int)
}

final class MainInteractor {

    private let service: MainServicing
    private let presenter: MainPresenting
    private var exchanges: [Exchange] = []
    private var logos: [ExchangeLogo] = []

    init(service: MainServicing, presenter: MainPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - MainInteracting
extension MainInteractor: MainInteracting {
    func didTapCell(index: Int) {
        let exchange = exchanges[index]
        let logo = logos.first(where: { $0.exchangeId == exchange.exchangeId })

        presenter.presentDetail(with: exchanges[index], and: logo)
    }
    
    func load() {
        presenter.presentLoading(with: true)
        Task {
            do {
                self.exchanges = try await service.loadExchanges()
                self.logos = try await service.loadExchangesLogos()
                presenter.presentLoading(with: false)
                self.presenter.presentExchangeList(exchanges: exchanges, logos: logos)
            } catch(let error) {
                presenter.presentLoading(with: false)
                print(error)
            }
        }
    }
}
