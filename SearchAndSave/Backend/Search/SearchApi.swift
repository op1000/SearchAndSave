//
//  SearchApi.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation

protocol SearchApiType {
    func searchVClip(query: String, page: Int) async throws -> SearchApi.VClipResponseDTO
    func searchImage(query: String, page: Int) async throws -> SearchApi.ImageResponseDTO
}

class SearchApi {
    enum APIError: Error {
        case invalidSearchKeyword
        case invalidURL
        case noData
    }
    
    private enum Constants {
        static let kakaoApiKey = "545713aabe1f1cd9663ab3016ef2a9e6"
        static let baseUrl = "https://dapi.kakao.com"
        static let searchImage = "/v2/search/image"
        static let searchMovie = "/v2/search/vclip"
        static let fetchCount = 20
    }
    
    private var api: URLSession?
    
    // MARK: - life cycle
    
    static let shared = SearchApi()
    
    init(api: URLSession = URLSession.shared) {
        self.api = api
    }
}

// MARK: - public

extension SearchApi: SearchApiType {
    func searchVClip(query: String, page: Int) async throws -> VClipResponseDTO {
        guard var components = URLComponents(string: Constants.baseUrl + Constants.searchMovie) else {
            throw APIError.invalidURL
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIError.invalidSearchKeyword
        }
        components.queryItems = [
          URLQueryItem(name: "query", value: "\(encodedQuery)"),
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "size", value: "\(Constants.fetchCount)"),
          URLQueryItem(name: "sort", value: "recency"),
        ]
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        guard let api else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(Constants.kakaoApiKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await api.data(for: request)
        logResponseString(data: data)
        
        let result = try JSONDecoder().decode(VClipResponseDTO.self, from: data)
        return result
    }
    
    func searchImage(query: String, page: Int) async throws -> ImageResponseDTO {
        guard var components = URLComponents(string: Constants.baseUrl + Constants.searchImage) else {
            throw APIError.invalidURL
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIError.invalidSearchKeyword
        }
        components.queryItems = [
          URLQueryItem(name: "query", value: "\(encodedQuery)"),
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "size", value: "\(Constants.fetchCount)"),
          URLQueryItem(name: "sort", value: "recency"),
        ]
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        guard let api else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(Constants.kakaoApiKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await api.data(for: request)
        logResponseString(data: data)
        
        let result = try JSONDecoder().decode(ImageResponseDTO.self, from: data)
        return result
    }
}

// MARK: - debugging

extension SearchApi {
    private func logResponseString(data: Data) {
        if let str = String(data: data, encoding: .utf8) {
            Logger.log("Successfully decoded: \(str)")
        }
    }
}
