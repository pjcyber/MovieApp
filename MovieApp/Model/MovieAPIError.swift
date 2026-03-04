//
//  MovieAPIError.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

enum MovieAPIError: Error, LocalizedError {
    case decodingError(underlying: Error)
    case invalidResponse
    case invalidURL
    case missingApiKey
    case networkError(Error)
    case unknown

    var errorDescription: String {
        switch self {
        case .decodingError(let underlying):
            return String(localized: "Decoding failed: \(underlying.localizedDescription)")
        case .invalidResponse:
            return String(localized: "Invalid server response.")
        case .invalidURL:
            return String(localized: "Invalid URL.")
        case .missingApiKey:
            return String(localized: "API key not configured. Set TMDB_API_KEY in Scheme environment or Info.plist.")
        case .networkError(let err):
            return String(localized: "Network error: \(err.localizedDescription)")
        case .unknown:
            return String(localized: "An unknown error occurred.")
        }
    }
}
