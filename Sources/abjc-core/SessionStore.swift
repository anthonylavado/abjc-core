//
//  SessionStore.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation
import abjc_api
import Security

public class SessionStore: ObservableObject {
    @Published public var preferences: PreferenceStore = PreferenceStore()
    @Published public var items: [API.Models.Item] = []
    @Published public var user: API.AuthUser? = nil
    @Published public var alert: AlertError? = nil
    
    @Published private(set) public var host: String = ""
    @Published private(set) public var port: Int = 8096
    
    public var api: API
    
    public var hasUser: Bool {
        return self.user != nil
    }
    
    public init() {
        self.user = nil
        self.api = API("", 8096)
    }
    
    
    /// Updates Cached Items
    /// - Parameter items: Array of fetched Items
    public func updateItems(_ items: [API.Models.Item]) {
        DispatchQueue.main.async {
            self.items.append(contentsOf: items.filter({!items.contains($0)}))
        }
    }
    
    
    /// Sets host, port and deviceID
    /// - Parameters:
    ///   - host: Hostname or IP-Adress
    ///   - port: Port for the Server
    ///   - deviceId: Unique DeviceID for this device
    /// - Returns: API object
    public func setServer(_ host: String, _ port: Int, _ deviceId: String) -> API {
        DispatchQueue.main.async {
            self.host = host
            self.port = port
        }
        if user != nil {
            self.api = API(self.host, self.port, self.user)
        } else {
            self.api = API(host, port, nil, deviceId)
        }
        print(self.api.host, self.api.port)
        return self.api
    }
    
    
    /// Clears the SessionScore
    public func clear() {
//        KeyChain.clear(key: "credentials")
        self.api = API("localhost", 8096)
        self.user = nil
    }
}
