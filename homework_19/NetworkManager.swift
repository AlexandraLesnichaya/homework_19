//
//  NetworkManager.swift
//  homework_19
//
//  Created by Александра Лесничая on 3/24/20.
//  Copyright © 2020 Alexandra Lesnichaya. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case parceError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class NetworkManager {
    static let shared = NetworkManager()

    func performRequest(_ request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    error == nil else {
                        completion(Result.failure(NetworkError.networkError))
                        return
                }
                completion(Result.success(data))
            }
        }
        task.resume()
    }

    func loadRates(completion: @escaping (Result<CurrencyModel, Error>) -> Void) {
        let request = URLRequest(url: URL(string: "http://data.fixer.io/api/latest?access_key=a79474f5780a2697956ee6a90ccd8bfa")!)

        performRequest(request) { result in
            switch result {
            case .success(let data):
                if let data = data,
                    let currencyModel = try? JSONDecoder().decode(CurrencyModel.self, from: data) {
                    completion(Result.success(currencyModel))
                } else {
                    completion(Result.failure(NetworkError.parceError))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
