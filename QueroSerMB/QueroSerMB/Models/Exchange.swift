//
//  Exchange.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import Foundation

struct Exchange: Codable, Equatable {
    let name: String?
    let exchangeId: String
    let dailyVolumeUsd: Double
    let hourVolumeUsd: Double
    let monthVolumeUsd: Double

    enum CodingKeys: String, CodingKey {
        case exchangeId = "exchange_id"
        case hourVolumeUsd = "volume_1hrs_usd"
        case dailyVolumeUsd = "volume_1day_usd"
        case monthVolumeUsd = "volume_1mth_usd"
        case name
    }
}
