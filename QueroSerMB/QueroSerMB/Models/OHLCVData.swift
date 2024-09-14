//
//  OHLCVData.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 14/09/24.
//

import Foundation

struct OHLCVData: Codable {
    let timePeriodStart: String
    let timePeriodEnd: String
    let timeOpen: String
    let timeClose: String
    
    let priceOpen: Double
    let priceHigh: Double
    let priceLow: Double
    let priceClose: Double
    let volumeTraded: Double
    let tradesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case timePeriodStart = "time_period_start"
        case timePeriodEnd = "time_period_end"
        case timeOpen = "time_open"
        case timeClose = "time_close"
        case priceOpen = "price_open"
        case priceHigh = "price_high"
        case priceLow = "price_low"
        case priceClose = "price_close"
        case volumeTraded = "volume_traded"
        case tradesCount = "trades_count"
    }
}
