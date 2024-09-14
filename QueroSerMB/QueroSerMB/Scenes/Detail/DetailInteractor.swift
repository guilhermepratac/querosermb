protocol DetailInteracting: AnyObject {
    func load()
}

final class DetailInteractor {
    private let service: DetailServicing
    private let presenter: DetailPresenting
    private let exchange: ExchangeDetail

    init(service: DetailServicing, presenter: DetailPresenting, exchange: ExchangeDetail) {
        self.service = service
        self.presenter = presenter
        self.exchange = exchange
    }
    
}

// MARK: - DetailInteracting
extension DetailInteractor: DetailInteracting {
    func load() {
        self.presenter.displayDetail(with: exchange)
    }
}
