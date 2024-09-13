protocol DetailServicing {
    typealias ExchangeDetailResult = Result<Exchange, ServiceError>

    func getExchangeDetail(id: String, _ completion: @escaping (ExchangeDetailResult) -> Void)
}

final class DetailService {
    private let coreService: CoreNetworkProtocol

    init(coreService: CoreNetworkProtocol) {
        self.coreService = coreService
    }
}

// MARK: - DetailServicing
extension DetailService: DetailServicing {
    func getExchangeDetail(id: String, _ completion: @escaping (ExchangeDetailResult) -> Void) {
        coreService.get(request: Router.getExchangeById(id: id).getRequest, of: Exchange.self) { result in
            completion(result)
        }
    }
}
