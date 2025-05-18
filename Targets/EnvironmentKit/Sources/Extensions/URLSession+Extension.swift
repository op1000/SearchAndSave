//
//  URLSession+Extension.swift
//  EnvironmentKit
//
//  Created by NakCheon Jung on 5/18/25.
//

import UIKit

public extension URLSession {
    func cachedData(for url: URL) async throws -> Data? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return cachedResponse.data
        } else {
            let (data, response) = try await URLSession.shared.data(for: request)
            let cacheResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cacheResponse, for: request)
            return data
        }
    }
    
    func cachedImage(for url: URL) async throws -> UIImage? {
        if let data = try await cachedData(for: url) {
            UIImage(data: data)
        } else {
            nil
        }
    }
}
