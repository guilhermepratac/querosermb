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
        }
    }

    var getRequest: URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = "GET"
        request.addValue(Router.apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        return request
    }
}
