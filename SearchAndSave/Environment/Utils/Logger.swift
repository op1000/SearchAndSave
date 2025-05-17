//
//  Logger.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation
import os.log

class Logger: NSObject {
    // Log 출력 (print 사용)
    static func log(fileName: String = #file, funcName: String = #function, _ log: String? = nil) {
#if DEBUG
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd HH:mm:ss.SSS"
        if let log {
            print(dateFormat.string(from: Date()) + " " + (fileName as NSString).lastPathComponent + " " + funcName + " " + log)
        } else {
            print(dateFormat.string(from: Date()) + " " + (fileName as NSString).lastPathComponent + " " + funcName)
        }
#endif
    }
}
