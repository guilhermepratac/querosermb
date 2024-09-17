//
//  ServiceError.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import Foundation

public enum ServiceError: Error, Equatable {
    case requestFailed(description: String)
    case emptyData
    case decodeError
    case errorUnknown
    case outOfBounds

    var localizedDescription: String {
        switch self {
        case .emptyData, .errorUnknown:
            return "Nenhum erro encontrando mas não obtevemos os dados necessários"
        case .requestFailed(description: let description):
            return "Erro na requisição: \(description)"
        case .decodeError:
            return "Não pode decodificar"
        case .outOfBounds:
            return "Dado não encontrado"
        }
    }
    
    var title: String {
        return "Houve um problema"
    }
}
