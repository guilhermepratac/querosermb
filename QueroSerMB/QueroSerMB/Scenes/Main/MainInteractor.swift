import Foundation

protocol MainInteracting: AnyObject {
    func load()
}

final class MainInteractor {

    private let service: MainServicing
    private let presenter: MainPresenting

    init(service: MainServicing, presenter: MainPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - MainInteracting
extension MainInteractor: MainInteracting {
    func load() {
        Task {
            do {
                let exchanges = try await service.loadExchanges()
                let logos = try await service.loadExchangesLogos()
                self.presenter.presentExchangeList(exchanges: exchanges, logos: logos)
            } catch(let error) {
               print(error)
            }
        }
    }
}
