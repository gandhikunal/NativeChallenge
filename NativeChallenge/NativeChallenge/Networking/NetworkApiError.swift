//
//  NetworkApiError.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import Foundation

enum NetworkApiError: Error {
    case networkError(Error)
    case httpErrorResponse(HTTPURLResponse)
    case noDataReturned
}

extension NetworkApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network request returned error: \(error.localizedDescription)"
        case .httpErrorResponse(let httpURLResponse):
            return "Network request returned HttpStatus code: \(httpURLResponse.statusCode)"
        case .noDataReturned:
            return "Network request returned no data"
        }
    }
}
