//
//  SearchedResultInfo.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation

struct SearchedResultInfo: Identifiable, Equatable, Hashable, Codable {
    var id: String
    let thumbnail: String
    let datetime: Date
    let playTime: Int?
    let imageUrl: String?
    var isBookmarked: Bool = false
    var bookmarkDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case thumbnail
        case datetime
        case playTime
        case imageUrl
        case bookmarkDate
        /// isBookmarked 는 제외
    }
    
    static func == (lhs: SearchedResultInfo, rhs: SearchedResultInfo) -> Bool {
        return lhs.id == rhs.id &&
        lhs.thumbnail == rhs.thumbnail &&
        lhs.datetime == rhs.datetime &&
        lhs.playTime == rhs.playTime &&
        lhs.imageUrl == rhs.imageUrl
        /// isBookmarked 는 비교에서 제외
    }
}

extension SearchedResultInfo {
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: datetime)
    }
    
    var formatPlayTime: String {
        guard let playTime else { return "00:00:00" }
        let hours = playTime / 3600
        let minutes = (playTime % 3600) / 60
        let secs = playTime % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%d:%02d", minutes, secs)
        }
    }
}

extension SearchedResultInfo {
    static func fromResponeDTO(_ dto: SearchApi.ImageDocument) -> Self? {
        guard let date = convertDate(dto.datetime) else { return nil }
        return .init(
            id: UUID().uuidString,
            thumbnail: dto.thumbnailUrl,
            datetime: date,
            playTime: nil,
            imageUrl: dto.imageUrl
        )
    }
    
    static func fromResponeDTO(_ dto: SearchApi.VClipDocument) -> Self? {
        guard let date = convertDate(dto.datetime) else { return nil }
        return .init(
            id: UUID().uuidString,
            thumbnail: dto.thumbnail,
            datetime: date,
            playTime: dto.playTime,
            imageUrl: nil
        )
    }
}

extension SearchedResultInfo {
    private static func convertDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
}
