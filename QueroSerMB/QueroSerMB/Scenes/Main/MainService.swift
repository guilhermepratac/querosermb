import Foundation

protocol MainServicing {
    func loadExchanges() async throws -> [Exchange]
    func loadExchangesLogos() async throws -> [ExchangeLogo]
}

final class MainService {
    private let coreService: CoreNetworkProtocol

    init(coreService: CoreNetworkProtocol) {
        self.coreService = coreService
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest, of type: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            coreService.get(request: request, of: type) { result in
                continuation.resume(with: result)
            }
        }
    }
}

// MARK: - MainServicing
extension MainService: MainServicing {
    func loadExchanges() async throws -> [Exchange] {
        let request = Router.getExchanges.getRequest
        return try await performRequest(request, of: [Exchange].self)
    }
    
    func loadExchangesLogos() async throws -> [ExchangeLogo] {
        let request = Router.getExchangesLogos.getRequest
        return try await performRequest(request, of: [ExchangeLogo].self)
    }
}
