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
    func data(from url: URL, completion: @escaping (Result<HTTPResponse, NetworkApiError>) -> ()) -> AnyCancelable?
}

struct HTTPResponse {
    let httpResponse: URLResponse?
    let data: Data
}

class NetworkManager {
    
    private let networkDataProvider: NetworkDataProvider
    static let shared = NetworkManager(networkDataProvider: URLSession.shared)
    
    init(networkDataProvider: NetworkDataProvider) {
        self.networkDataProvider = networkDataProvider
    }
    
    func fetchData(from url: URL, completionHandler: @escaping (Result<HTTPResponse, NetworkApiError>) -> ()) -> AnyCancelable? {
        networkDataProvider.data(from: url) { result in
            completionHandler(result)
        }
    }
}

extension URLSessionDataTask: AnyCancelable {}

extension URLSession: NetworkDataProvider {
   
    func data(from url: URL, completion: @escaping (Result<HTTPResponse, NetworkApiError>) -> ()) -> AnyCancelable? {
        let request = URLRequest(url: url)
        let task = dataTask(with: request) { data, response, err in
            if let err = err {
                completion(.failure(NetworkApiError.networkError(err)))
            } else if let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode >= 400 {
                completion(.failure(NetworkApiError.httpErrorResponse(httpUrlResponse)))
            } else if let data = data {
                completion(.success(HTTPResponse(httpResponse: response, data: data)))
            } else {
                completion(.failure(NetworkApiError.noDataReturned))
            }
        }
        task.resume()
        return task
    }
}
