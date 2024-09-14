protocol DetailInteracting: AnyObject {
    func loadSomething()
}

final class DetailInteractor {
    private let service: DetailServicing
    private let presenter: DetailPresenting
    private let exchangeID: String

    init(service: DetailServicing, presenter: DetailPresenting, exchangeID: String) {
        self.service = service
        self.presenter = presenter
        self.exchangeID = exchangeID
    }
    
}

// MARK: - DetailInteracting
extension DetailInteractor: DetailInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
