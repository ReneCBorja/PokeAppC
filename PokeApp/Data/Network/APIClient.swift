//
//  APIClient.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation
import Combine

final class APIClient {

    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
