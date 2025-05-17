//
//  BackendService.swift
//  SearchAndSave
//
//  Created by NakCheon Jung on 5/17/25.
//

import Foundation

public class BackendService {
    private enum Constants {
        static let kakaoApiKey = "545713aabe1f1cd9663ab3016ef2a9e6"
        static let expireTimeInSeconds: TimeInterval = 300 // 5분
    }
    
    enum APIError: Error {
        case invalidSearchKeyword
        case invalidURL
        case invalidResponse
        case noData
    }
    
    private var cacheInfo: [String: Date] = [:]
    
    public init() {}
    
    func request<T: Decodable>(_ request: URLRequest, session: URLSession) async throws -> T {
        if let cachedResponse = URLCache.shared.cachedResponse(for: request), !isExpired(request) {
            return try JSONDecoder().decode(T.self, from: cachedResponse.data)
        }
        
        var requstToSend = request
        requstToSend.setValue("KakaoAK \(Constants.kakaoApiKey)", forHTTPHeaderField: "Authorization")
        requstToSend.cachePolicy = .returnCacheDataElseLoad
        
        let (data, response) = try await session.data(for: requstToSend)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
            throw APIError.invalidResponse
        }
        
        if let urlString = request.url?.absoluteString {
            cacheInfo[urlString] = Date()
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension BackendService {
    private func isExpired(_ request: URLRequest) -> Bool {
        guard let urlString = request.url?.absoluteString,
              let cachedDate = cacheInfo[urlString] else {
            return true
        }
        let isExpired = Date().timeIntervalSince(cachedDate) > Constants.expireTimeInSeconds
        return isExpired
    }
}
