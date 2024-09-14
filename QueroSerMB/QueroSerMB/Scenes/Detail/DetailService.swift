import Foundation

protocol DetailServicing {
    typealias ExchangeDetailResult = Result<[OHLCVData], ServiceError>

    func getOhlcv(spot: String,timeStart: String, timeEnd: String,  _ completion: @escaping (ExchangeDetailResult) -> Void)
}

final class DetailService {
    private let coreService: CoreNetworkProtocol

    init(coreService: CoreNetworkProtocol) {
        self.coreService = coreService
    }
}

// MARK: - DetailServicing
extension DetailService: DetailServicing {
    func getOhlcv(spot: String, timeStart: String, timeEnd: String, _ completion: @escaping (ExchangeDetailResult) -> Void) {
        let request = Router.getOhlcvBySpot(spot: spot, timeStart: timeStart, timeEnd: timeEnd).getRequest
        coreService.get(request: request, of: [OHLCVData].self) { result in
            completion(result)
        }
    }
}
