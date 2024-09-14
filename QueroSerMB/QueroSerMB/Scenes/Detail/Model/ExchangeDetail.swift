import Foundation

struct ExchangeDetail {
    let urlImage: String?
    let name: String
    let exchangeId: String
    let hourVolumeUsd: String
    let dailyVolumeUsd: String
    let monthVolumeUsd: String

    enum CodingKeys: String, CodingKey {
        case exchangeId = "exchange_id"
        case hourVolumeUsd = "volume_1hrs_usd"
        case dailyVolumeUsd = "volume_1day_usd"
        case monthVolumeUsd = "volume_1mth_usd"
        case name
    }
}


