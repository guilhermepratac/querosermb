//
//  ExchangeLogo.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import Foundation

struct ExchangeLogo: Decodable, Equatable {
    let exchangeId: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case exchangeId = "exchange_id"
        case url
    }
}
