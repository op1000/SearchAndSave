//
//  Array+Extension.swift
//  EnvironmentKit
//
//  Created by NakCheon Jung on 5/18/25.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
