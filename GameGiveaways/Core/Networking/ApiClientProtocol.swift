//
//  ApiClientProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Moya
import CombineMoya
import Combine
import Foundation

protocol ApiClientProtocol {
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, Error>
}

class ApiClient: ApiClientProtocol {
    private let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin()])

    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, Error> {
        provider.requestPublisher(MultiTarget(target))
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
