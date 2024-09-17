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
        presenter.displayDetail(with: self.exchange)
        presenter.displayLoading(with: true)
        
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
                self.presenter.displayLoading(with: false)
                self.presenter.displayChart(with: datas)
            case .failure:
                self.getSpotUSDT()
            }
        }
    }
    
    func getSpotUSDT() {
        let spot = "\(exchange.exchangeId)_SPOT_BTC_USDC"
        let timeEnd = Date()
        guard let timeStart = Calendar.current.date(byAdding: .day, value: -1, to: timeEnd) else {
            return
        }
        
        service.getOhlcv(
            spot: spot,
            timeStart: timeStart.toString(format: .iso8601),
            timeEnd: timeEnd.toString(format: .iso8601)
        ) { result in
            
            self.presenter.displayLoading(with: false)
            switch result {
            case .success(let datas):
                self.presenter.displayLoading(with: false)
                self.presenter.displayChart(with: datas)
            case .failure(let error):
                self.presenter.presentErrorChart(with: error)
            }
        }
    }
    
}
