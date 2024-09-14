//
//  Router.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import Foundation


enum Router {

    case getExchanges
    case getExchangesLogos
    case getExchangeById(id: String)
    case getOhlcvBySpot(spot: String, timeStart: String, timeEnd: String)

    static private let baseURL: String = "https://rest.coinapi.io/v1"
    static private let apiKey: String = ""

    var url: URL {
        URL(string: Self.baseURL+self.path)!
    }

    private var path: String {
        switch self {
        case .getExchanges:
            return "/exchanges"
        case .getExchangesLogos:
            return "/exchanges/icons/40"
        case .getExchangeById(let id):
            return "/exchanges/\(id)"
        case .getOhlcvBySpot(let spot, _, _):
            return "/ohlcv/\(spot)/history"
        }
    }
    
    private var params: [String: String] {
        switch self {
        case .getExchanges, .getExchangesLogos, .getExchangeById:
            return [:]
        case .getOhlcvBySpot(_, let timeStart, let timeEnd):
            return [
                "time_start": timeStart,
                "time_end": timeEnd,
                "period_id": "1HRS"
            ]
        }
    }
    

    var getRequest: URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Router.apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        request.url = components?.url
        
        
        return request
    }
}
