protocol DetailPresenting: AnyObject {
    func displayDetail(with model: ExchangeDetail)
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
    func displayDetail(with model: ExchangeDetail) {
        viewController?.displayDetail(
            urlImage: model.urlImage,
            name: model.name,
            exchangeID: model.exchangeId,
            price: model.dailyVolumeUsd
        )
    }
}
