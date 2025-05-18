//
//  CachedImageStorage.swift
//  EnvironmentKit
//
//  Created by NakCheon Jung on 5/18/25.
//

import UIKit
import EnvironmentKit

public enum CachedImageStorage: Sendable {
    public static func cachedImage(for url: URL) async throws -> UIImage? {
        try await URLSession.shared.cachedImage(for: url)
    }
}
