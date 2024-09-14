import Foundation

protocol MainInteracting: AnyObject {
    func load()
    func didTapCell(index: Int)
}

final class MainInteractor {

    private let service: MainServicing
    private let presenter: MainPresenting
    private var exchanges: [Exchange] = []

    init(service: MainServicing, presenter: MainPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - MainInteracting
extension MainInteractor: MainInteracting {
    func didTapCell(index: Int) {
        presenter.presentDetail(with: exchanges[index].exchangeId)
    }
    
    func load() {
        Task {
            do {
                self.exchanges = try await service.loadExchanges()
                let logos = try await service.loadExchangesLogos()
                self.presenter.presentExchangeList(exchanges: exchanges, logos: logos)
            } catch(let error) {
               print(error)
            }
        }
    }
}
