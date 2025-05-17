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
    private enum Constants {
        static let baseUrl = "https://dapi.kakao.com"
        static let searchImage = "/v2/search/image"
        static let searchMovie = "/v2/search/vclip"
        static let fetchCount = 20
    }
    
    private var api: URLSession
    private let backendService: BackendService
    
    // MARK: - life cycle
    
    static let shared = SearchApi()
    
    init(
        api: URLSession = URLSession.shared,
        backendService: BackendService = BackendService()
    ) {
        self.api = api
        self.backendService = backendService
    }
}

// MARK: - public

extension SearchApi: SearchApiType {
    func searchVClip(query: String, page: Int) async throws -> VClipResponseDTO {
        guard var components = URLComponents(string: Constants.baseUrl + Constants.searchMovie) else {
            throw BackendService.APIError.invalidURL
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw BackendService.APIError.invalidSearchKeyword
        }
        components.queryItems = [
          URLQueryItem(name: "query", value: "\(encodedQuery)"),
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "size", value: "\(Constants.fetchCount)"),
          URLQueryItem(name: "sort", value: "recency"),
        ]
        guard let url = components.url else {
            throw BackendService.APIError.invalidURL
        }
        
        let request = URLRequest(url: url)
        let result: VClipResponseDTO = try await backendService.request(request, session: api)
        return result
    }
    
    func searchImage(query: String, page: Int) async throws -> ImageResponseDTO {
        guard var components = URLComponents(string: Constants.baseUrl + Constants.searchImage) else {
            throw BackendService.APIError.invalidURL
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw BackendService.APIError.invalidSearchKeyword
        }
        components.queryItems = [
          URLQueryItem(name: "query", value: "\(encodedQuery)"),
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "size", value: "\(Constants.fetchCount)"),
          URLQueryItem(name: "sort", value: "recency"),
        ]
        guard let url = components.url else {
            throw BackendService.APIError.invalidURL
        }
        let request = URLRequest(url: url)
        let result: ImageResponseDTO = try await backendService.request(request, session: api)
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
