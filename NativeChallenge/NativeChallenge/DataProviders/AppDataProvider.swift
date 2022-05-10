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
    var carMakesEndPoint: URL { get set }
}

protocol CarMakesDataProviderDelegate: AnyObject {
    func fetchCarMakesDidFinish(_ dataprovider: CarMakesDataProvider, withResult result: Result<[CarMake], Error>)
}

class AppDataProvider: CarMakesDataProvider {
    
    private let manager: NetworkManager
    weak var carMakesProviderDelegate: CarMakesDataProviderDelegate?
    var carMakesEndPoint: URL = {
        if ProcessInfo.processInfo.environment["read_carmakes_from_disk"] == "1" {
            guard let url = Bundle.main.url(forResource: "CarMakesList", withExtension: "json") else {
                fatalError("We would like to use a local file, however such cannot be found in the bundle.")
            }
            return url
        } else {
            return URL(string: "https://actual-endpoint-to-be-queried")!
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
                    let decodedType: T = try self.transformData(response.data)
                    completion(.success(decodedType))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func fetchCarMakes() -> AnyCancelable? {
        return fetchData(from: carMakesEndPoint) { [weak self] (result: Result<[CarMake], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let makes):
                self.carMakesProviderDelegate?.fetchCarMakesDidFinish(self, withResult: .success(makes))
            case .failure(let error):
                self.carMakesProviderDelegate?.fetchCarMakesDidFinish(self, withResult: .failure(error))
            }
        }
    }
}
