import Foundation

protocol DetailPresenting: AnyObject {
    func displayDetail(with model: ExchangeDetail)
    func displayChart(with data: [OHLCVData])
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
    func displayChart(with data: [OHLCVData]) {
        let chartData = data.map { data in
            return (data.timePeriodStart.toDate(format: .iso8601) ?? Date(), data.volumeTraded)
        }
        
        viewController?.displayChart(data: chartData)
    }
    
    func displayDetail(with model: ExchangeDetail) {
        viewController?.displayDetail(
            urlImage: model.urlImage,
            name: model.name,
            exchangeID: model.exchangeId,
            price: model.dailyVolumeUsd
        )
    }
}
