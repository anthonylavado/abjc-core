//
//  File.swift
//  
//
//  Created by Noah Kamara on 18.11.20.
//

import Foundation

public struct Version: Codable, CustomStringConvertible {
    
    public var description: String {
        if isTestFlight {
            return "[BETA] \(major).\(minor).\(patch) (\(build!))"
        } else {
            return "\(major).\(minor).\(patch)"
        }
    }
    
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let build: Int?
    
    public var isTestFlight: Bool {
        return build != nil
    }
    
    public init(_ major: Int, _ minor: Int, _ patch: Int, _ build: Int? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.build = build
    }
}
