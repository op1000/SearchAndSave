//
//  SearchDto.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation

public extension SearchApi {
    struct ImageResponseDTO: Decodable {
        public let meta: Meta
        public let documents: [ImageDocument]
        
        public init(meta: Meta, documents: [ImageDocument]) {
            self.meta = meta
            self.documents = documents
        }
    }
    
    struct VClipResponseDTO: Decodable {
        public let meta: Meta
        public let documents: [VClipDocument]
        
        public init(meta: Meta, documents: [VClipDocument]) {
            self.meta = meta
            self.documents = documents
        }
    }
    
    struct Meta: Decodable {
        public let totalCount: Int
        public let pageableCount: Int
        public let isEnd: Bool

        public enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case pageableCount = "pageable_count"
            case isEnd = "is_end"
        }
        
        public init(totalCount: Int, pageableCount: Int, isEnd: Bool) {
            self.totalCount = totalCount
            self.pageableCount = pageableCount
            self.isEnd = isEnd
        }
    }
    
    /// NOTE: vclip 과 image 에서 공통 필드만 처리
    struct ImageDocument: Decodable {
        public let thumbnailUrl: String
        public let datetime: String
        public let imageUrl: String
        
        public enum CodingKeys: String, CodingKey {
            case thumbnailUrl = "thumbnail_url"
            case datetime
            case imageUrl = "image_url"
        }
        
        public init(thumbnailUrl: String, datetime: String, imageUrl: String) {
            self.thumbnailUrl = thumbnailUrl
            self.datetime = datetime
            self.imageUrl = imageUrl
        }
    }
    
    struct VClipDocument: Decodable {
        public let thumbnail: String
        public let datetime: String
        public let playTime: Int
        
        public enum CodingKeys: String, CodingKey {
            case playTime = "play_time"
            case thumbnail = "thumbnail"
            case datetime
        }
        
        public init(thumbnail: String, datetime: String, playTime: Int) {
            self.thumbnail = thumbnail
            self.datetime = datetime
            self.playTime = playTime
        }
    }
}
