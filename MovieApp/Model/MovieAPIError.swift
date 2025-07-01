//
//  MovieAPIError.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

enum MovieAPIError: Error,LocalizedError {
    case decodingError(underlying: Error)
    case invalidResponse
    case invalidURL
    case networkError(Error)
    case unknown

    var errorDescription: String {
        switch self {
        case .decodingError(let underlying):
            return "Decoding failed: \(underlying.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response."
        case .invalidURL:
            return "Invalid URL."
        case .networkError(let err):
            return "Network error: \(err.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
