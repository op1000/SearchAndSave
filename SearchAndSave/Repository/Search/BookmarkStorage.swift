//
//  BookmarkStorage.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/16/25.
//

import Foundation

protocol BookmarkStorageType {
    func saveBookmark(_ bookmark: SearchedResultInfo) async
    func saveBookmarks(_ bookmarks: [SearchedResultInfo]) async
    func loadSavedBookmarks() async -> [SearchedResultInfo]
    func removeBookmark(_ bookmark: SearchedResultInfo) async
}

@globalActor
actor BookmarkStorage {
    let storage: StorageType
    
    // MARK: - life cycle
    static let shared = BookmarkStorage()
    init(storage: StorageType = Storage.shared) {
        self.storage = storage
    }
}

extension BookmarkStorage: BookmarkStorageType {
    func saveBookmark(_ bookmark: SearchedResultInfo) {
        if let stored = storage.loadDefaults(key: .bookmark) as? Data,
           var bookmarks = try? JSONDecoder().decode([SearchedResultInfo].self, from: stored) {
            /// 저장된 정보 있음
            if let matchingItem = bookmarks.filter({ $0.thumbnail == bookmark.thumbnail }).first,
               let index = bookmarks.firstIndex(of: matchingItem) {
                // update
                bookmarks.remove(at: index)
                bookmarks.append(bookmark)
            } else {
                // add
                bookmarks.append(bookmark)
            }
            guard let encoded = try? JSONEncoder().encode(bookmarks) else { return }
            storage.saveDefaults(key: .bookmark, val: encoded)
        } else {
            /// 저장된 정보 없음
            guard let encoded = try? JSONEncoder().encode([bookmark]) else { return }
            storage.saveDefaults(key: .bookmark, val: encoded)
        }
    }
    
    func saveBookmarks(_ bookmarks: [SearchedResultInfo]) {
        guard let encoded = try? JSONEncoder().encode(bookmarks) else { return }
        storage.saveDefaults(key: .bookmark, val: encoded)
    }
    
    func loadSavedBookmarks() -> [SearchedResultInfo] {
        guard let stored = storage.loadDefaults(key: .bookmark) as? Data,
              let bookmarks = try? JSONDecoder().decode([SearchedResultInfo].self, from: stored) else { return [] }
        return bookmarks.sorted { $0.datetime > $1.datetime }
    }
    
    func removeBookmark(_ bookmark: SearchedResultInfo) {
        guard let stored = storage.loadDefaults(key: .bookmark) as? Data,
              var bookmarks = try? JSONDecoder().decode([SearchedResultInfo].self, from: stored) else { return }
        if let matchingItem = bookmarks.filter({ $0.thumbnail == bookmark.thumbnail }).first,
           let index = bookmarks.firstIndex(of: matchingItem) {
            bookmarks.remove(at: index)
            saveBookmarks(bookmarks)
        }
    }
}

