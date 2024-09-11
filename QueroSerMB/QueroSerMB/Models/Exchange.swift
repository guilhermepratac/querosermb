//
//  Exchange.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import Foundation

struct Exchange: Decodable, Equatable {
    let name: String?
    let exchangeId: String
    let dailyVolumeUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case exchangeId = "exchange_id"
        case dailyVolumeUsd = "volume_1day_usd"
        case name
    }
}
