import Foundation

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
        self.presenter.displayDetail(with: self.exchange)
        
        let spot = "\(exchange.exchangeId)_SPOT_BTC_USD"
        let timeEnd = Date()
        guard let timeStart = Calendar.current.date(byAdding: .day, value: -1, to: timeEnd) else {
            return
        }
        
        service.getOhlcv(
            spot: spot,
            timeStart: timeStart.toString(format: .iso8601),
            timeEnd: timeEnd.toString(format: .iso8601)
        ) { result in
            switch result {
            case .success(let datas):
                self.presenter.displayChart(with: datas)
            case .failure(let error):
                print(error)
            }
        }
    }
}
