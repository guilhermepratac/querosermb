import Foundation

protocol DetailPresenting: AnyObject {
    func displayDetail(with model: ExchangeDetail)
    func displayChart(with data: [OHLCVData])
    func presentErrorChart(with error: ServiceError)
    func displayLoading(with show: Bool)
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
    func displayLoading(with show: Bool) {
        if show {
            viewController?.displayLoading()
        } else {
            viewController?.dismissLoading()
        }
    }
    
    func presentErrorChart(with error: ServiceError) {
        viewController?.displayChartError(title: error.title, message: error.localizedDescription, button: "Tente novamente")
    }
    
    func displayChart(with data: [OHLCVData]) {
        let chartData = data.map { data in
            return (data.timePeriodStart.toDate(format: .iso8601) ?? Date(), data.volumeTraded)
        }
        
        viewController?.displayChart(data: chartData)
    }
    
    func displayDetail(with model: ExchangeDetail) {
        let data = ExchangeInformationModel(
            urlImage: model.urlImage,
            name: model.name,
            exchangeId: "ID: \(model.exchangeId)",
            hourVolume: "Volume de última hora: \(model.hourVolumeUsd)",
            dailyVolume: "Volume de último dia: \(model.hourVolumeUsd)",
            monthVolume: "Volume de último mês: \(model.monthVolumeUsd)"
        )
        
        viewController?.displayDetail(with: data)
    }
}
