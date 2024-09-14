protocol DetailPresenting: AnyObject {
    func displaySomething()
    func didNextStep()
}

final class DetailPresenter {
    private let coordinator: DetailCoordinating
    weak var viewController: DetailDisplaying?

    init(coordinator: DetailCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - DetailPresenting
extension DetailPresenter: DetailPresenting {
    func displaySomething() {
        viewController?.displayDetail(
            urlImage: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_512/5503eb9673f9437988702f06cbd7072b.png",
                                      name: "Bitcoin",
                                      exchangeID: "ID",
                                      price: "30 REAIS"
        )
    }
    
    func didNextStep() {
        coordinator.openSomething()
    }
}
