//
//  AlertError.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation
import SwiftUI
import Combine

public class AlertError: Identifiable, ObservableObject {
    public var id: Date
    private(set) public var title: LocalizedStringKey
    public var description: LocalizedStringKey
    
    public init(_ title: LocalizedStringKey, _ descr: LocalizedStringKey) {
        self.id = Date()
        self.title = title
        self.description = descr
    }
    
    public init(_ title: String, _ descr: String) {
        self.id = Date()
        self.title = LocalizedStringKey(title)
        self.description = LocalizedStringKey(descr)
    }
    
    public init(_ title: String, _ error: Error) {
        self.id = Date()
        self.title = LocalizedStringKey(title)
        self.description = LocalizedStringKey(error.string)
    }
    
    public init(_ title: LocalizedStringKey, _ error: Error) {
        self.id = Date()
        self.title = title
        self.description = LocalizedStringKey(error.string)
        
    }
}


extension Error {
    public var string: String {
        print(self)
        return self.localizedDescription
    }
}
