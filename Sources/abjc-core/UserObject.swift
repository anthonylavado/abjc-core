//
//  File.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation
import Combine

class UserObject: ObservableObject {
    private(set) public var userId: String
    private(set) public var serverId: String
    private(set) public var accessToken: String
    
    public init(_ userId: String, _ serverId: String, _ accessToken: String) {
        self.userId = userId
        self.serverId = serverId
        self.accessToken = accessToken
    }
}
