//
//  BackendService.swift
//  SearchAndSave
//
//  Created by NakCheon Jung on 5/17/25.
//

import Foundation
import EnvironmentKit

public class BackendService {

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
        let bundle = Bundle(for: BackendService.self)
        if let apiKey = bundle.object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String {
            requstToSend.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        }
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
        let isExpired = Date().timeIntervalSince(cachedDate) > Constant.Caching.timeoutInSec
        return isExpired
    }
}
