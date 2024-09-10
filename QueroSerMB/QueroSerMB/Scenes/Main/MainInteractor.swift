import Foundation

protocol MainInteracting: AnyObject {
    func loadSomething()
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
    func loadSomething() {
        presenter.displaySomething()
    }
}
