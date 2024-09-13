protocol DetailInteracting: AnyObject {
    func loadSomething()
}

final class DetailInteractor {
    private let service: DetailServicing
    private let presenter: DetailPresenting

    init(service: DetailServicing, presenter: DetailPresenting) {
        self.service = service
        self.presenter = presenter
    }
    
}

// MARK: - DetailInteracting
extension DetailInteractor: DetailInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
