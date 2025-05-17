//
//  BookmarkStorage.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/16/25.
//

import Foundation
import domainKit

public protocol BookmarkStorageType {
    func saveBookmark(_ bookmark: SearchedResultInfo) async
    func saveBookmarks(_ bookmarks: [SearchedResultInfo]) async
    func loadSavedBookmarks() async -> [SearchedResultInfo]
    func removeBookmark(_ bookmark: SearchedResultInfo) async
}

@globalActor
public actor BookmarkStorage {
    let storage: StorageType
    
    // MARK: - life cycle
    public static let shared = BookmarkStorage()
    private init(storage: StorageType = Storage.shared) {
        self.storage = storage
    }
}

extension BookmarkStorage: BookmarkStorageType {
    public func saveBookmark(_ bookmark: SearchedResultInfo) {
        if let stored = storage.loadDefaults(key: .bookmark) as? Data,
           var bookmarks = try? JSONDecoder().decode([SearchedResultInfo].self, from: stored) {
            /// 저장된 정보 있음
            if let matchingItem = bookmarks.first(where: { $0.thumbnail == bookmark.thumbnail }),
               let index = bookmarks.firstIndex(of: matchingItem) {
                // update
                bookmarks.remove(at: index)
                var bookmarkToSave = bookmark
                bookmarkToSave.bookmarkDate = Date()
                bookmarks.append(bookmarkToSave)
            } else {
                // add
                var bookmarkToSave = bookmark
                bookmarkToSave.bookmarkDate = Date()
                bookmarks.append(bookmarkToSave)
            }
            guard let encoded = try? JSONEncoder().encode(bookmarks) else { return }
            storage.saveDefaults(key: .bookmark, val: encoded)
        } else {
            /// 저장된 정보 없음
            var bookmarkToSave = bookmark
            bookmarkToSave.bookmarkDate = Date()
            guard let encoded = try? JSONEncoder().encode([bookmarkToSave]) else { return }
            storage.saveDefaults(key: .bookmark, val: encoded)
        }
    }
    
    public func saveBookmarks(_ bookmarks: [SearchedResultInfo]) {
        guard let encoded = try? JSONEncoder().encode(bookmarks) else { return }
        storage.saveDefaults(key: .bookmark, val: encoded)
    }
    
    public func loadSavedBookmarks() -> [SearchedResultInfo] {
        guard let stored = storage.loadDefaults(key: .bookmark) as? Data,
              let bookmarks = try? JSONDecoder().decode([SearchedResultInfo].self, from: stored) else { return [] }
        return bookmarks.sorted { $0.bookmarkDate ?? $0.datetime > $1.bookmarkDate ?? $0.datetime }
    }
    
    public func removeBookmark(_ bookmark: SearchedResultInfo) {
        guard let stored = storage.loadDefaults(key: .bookmark) as? Data,
              var bookmarks = try? JSONDecoder().decode([SearchedResultInfo].self, from: stored) else { return }
        if let matchingItem = bookmarks.first(where: { $0.thumbnail == bookmark.thumbnail }),
           let index = bookmarks.firstIndex(of: matchingItem) {
            bookmarks.remove(at: index)
            saveBookmarks(bookmarks)
        }
    }
}

