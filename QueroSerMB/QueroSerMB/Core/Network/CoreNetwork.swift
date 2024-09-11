//
//  APIService.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import Foundation

protocol CoreNetworkProtocol {
    func get<T: Decodable>(request: URLRequest, of type: T.Type, completion: @escaping (Result<T, ServiceError>) -> Void)
}

class CoreNetwork: CoreNetworkProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<T: Decodable>(request: URLRequest, of type: T.Type, completion: @escaping (Result<T, ServiceError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(description: error.localizedDescription)))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(.emptyData))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)

                completion(.success(decodedObject))
            } catch (let error){
                print(error)
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}
