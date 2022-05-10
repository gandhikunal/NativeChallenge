//
//  AppDataProvider.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import Foundation

protocol CarMakesDataProvider: AnyObject {
    func fetchCarMakes() -> AnyCancelable?
    var carMakesProviderDelegate: CarMakesDataProviderDelegate? { get set }
    //TODO: Make non-optional and throw fatalError
    var carMakesEndPoint: URL? { get set }
}

protocol CarMakesDataProviderDelegate: AnyObject {
    func fetchCarMakesDidFinish(_ dataprovider: CarMakesDataProvider, withResult result: Result<[CarMake], Error>)
}

class AppDataProvider: CarMakesDataProvider {
    
    private let manager: NetworkManager
    weak var carMakesProviderDelegate: CarMakesDataProviderDelegate?
    var carMakesEndPoint: URL? = {
        if ProcessInfo.processInfo.environment["read_carmakes_from_disk"] == "1" {
            guard let url = Bundle.main.url(forResource: "CarMakesList", withExtension: "json") else {
                return nil
            }
            return url
        } else {
            //TODO: Implicity unwrap, since we would be hardcoding it anyways
            return URL(string: "https://actual-endpoint-to-be-queried")
        }
    }()
    
    init(manager: NetworkManager = .shared) {
        self.manager = manager
    }
    
    private func transformData<T: Codable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    private func fetchData<T: Codable>(from url: URL, completion: @escaping ((Result<T, Error>) -> ())) -> AnyCancelable? {
        return manager.fetchData(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    if let data = response.data {
                        let decodedType: T = try self.transformData(data)
                        completion(.success(decodedType))
                    } else {
                        completion(.failure(NSError(domain: "NetworkError", code: 100, userInfo: ["Response Code": "\(String(describing: response.httpResponse))"])))
                    }
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func fetchCarMakes() -> AnyCancelable? {
        guard let url = carMakesEndPoint else {
            carMakesProviderDelegate?.fetchCarMakesDidFinish(self, withResult: .failure(NSError(domain: "AppDataProviderError", code: 0, userInfo: ["Reason" : "CarMakes endpoint is nil"])))
            return nil
        }
        
        return fetchData(from: url) { (result: Result<[CarMake], Error>) in
            switch result {
            case .success(let makes):
                self.carMakesProviderDelegate?.fetchCarMakesDidFinish(self, withResult: .success(makes))
            case .failure(let error):
                self.carMakesProviderDelegate?.fetchCarMakesDidFinish(self, withResult: .failure(error))
            }
        }
    }
}
