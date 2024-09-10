//
//  ServiceError.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import Foundation

enum ServiceError: Error {
    case requestFailed(description: String)
    case emptyData
    case decodeError

    var localizedDescription: String {
        switch self {
        case .emptyData:
            return "Nenhum erro encontrando mas não obtevemos os dados necessários"
        case .requestFailed(description: let description):
            return "Erro na requisição: \(description)"
        case .decodeError:
            return "Não pode decodificar"
        }
    }
}
