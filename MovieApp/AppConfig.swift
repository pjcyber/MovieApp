//
//  AppConfig.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

enum AppConfig {
    /// TMDB API key. Sources (first non-nil wins):
    /// 1. Environment variable TMDB_API_KEY (Scheme → Run → Arguments → Environment Variables)
    /// 2. Info.plist key "TMDB_API_KEY"
    /// 3. Debug only: fallback so the app runs without setup (replace with your own key for production)
    static var tmdbApiKey: String? {
        if let env = ProcessInfo.processInfo.environment["TMDB_API_KEY"], !env.isEmpty {
            return env
        }
        if let plist = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String, !plist.isEmpty {
            return plist
        }
        #if DEBUG
        // Development fallback so the app runs without configuring the scheme. For production, set TMDB_API_KEY.
        return "fb4b63165f5ce5680e1904b9cd40ba73"
        //return ""
        #else
        return nil
        #endif
    }

    // MARK: - Network

    static let tmdbAPIBaseURL = "https://api.themoviedb.org/3"
    static let tmdbPosterBaseURL = "https://image.tmdb.org/t/p/w500"

    // MARK: - Search
    /// Debounce delay for search input (350 nanoseconds).
    static let searchDebounceNanoseconds: UInt64 = 350_000_000

    // MARK: - Image cache

    // 50 MB
    static let urlCacheMemoryCapacity = 50 * 1024 * 1024
    // 100 MB
    static let urlCacheDiskCapacity = 100 * 1024 * 1024
}
