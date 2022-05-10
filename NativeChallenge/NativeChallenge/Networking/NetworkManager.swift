//
//  NetworkManager'.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import Foundation

protocol AnyCancelable {
    func cancel()
}

protocol NetworkDataProvider {
    func data(from url: URL, completion: @escaping (Result<HTTPResponse, Error>) -> ()) -> AnyCancelable?
}

struct HTTPResponse {
    let httpResponse: URLResponse?
    let data: Data?
}

class NetworkManager {
    
    private let networkDataProvider: NetworkDataProvider
    static let shared = NetworkManager(networkDataProvider: URLSession.shared)
    
    init(networkDataProvider: NetworkDataProvider) {
        self.networkDataProvider = networkDataProvider
    }
    
    func fetchData(from url: URL, completionHandler: @escaping (Result<HTTPResponse, Error>) -> ()) -> AnyCancelable? {
        networkDataProvider.data(from: url) { result in
            completionHandler(result)
        }
    }
}

extension URLSessionDataTask: AnyCancelable {}

extension URLSession: NetworkDataProvider {
   
    func data(from url: URL, completion: @escaping (Result<HTTPResponse, Error>) -> ()) -> AnyCancelable? {
        let request = URLRequest(url: url)
        let task = dataTask(with: request) { data, response, err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(HTTPResponse(httpResponse: response, data: data)))
            }
        }
        task.resume()
        return task
    }
}
