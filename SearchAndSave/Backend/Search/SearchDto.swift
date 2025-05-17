//
//  SearchDto.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation

extension SearchApi {
    struct ImageResponseDTO: Decodable {
        let meta: Meta
        let documents: [ImageDocument]
    }
    
    struct VClipResponseDTO: Decodable {
        let meta: Meta
        let documents: [VClipDocument]
    }
    
    struct Meta: Decodable {
        let totalCount: Int
        let pageableCount: Int
        let isEnd: Bool

        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case pageableCount = "pageable_count"
            case isEnd = "is_end"
        }
    }
    
    /// NOTE: vclip 과 image 에서 공통 필드만 처리
    struct ImageDocument: Decodable {
        let thumbnailUrl: String
        let datetime: String
        let imageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case thumbnailUrl = "thumbnail_url"
            case datetime
            case imageUrl = "image_url"
        }
    }
    
    struct VClipDocument: Decodable {
        let thumbnail: String
        let datetime: String
        let playTime: Int
        
        enum CodingKeys: String, CodingKey {
            case playTime = "play_time"
            case thumbnail = "thumbnail"
            case datetime
        }
    }
}
