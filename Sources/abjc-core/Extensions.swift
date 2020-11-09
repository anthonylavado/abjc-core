//
//  File.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation

public extension Data {
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}


public extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(where: {$0.hashValue == elem.hashValue}) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
