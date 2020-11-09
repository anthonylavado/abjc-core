//
//  AlertError.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation
import Combine

public class AlertError: Identifiable, ObservableObject {
    public var id: Date
    private(set) public var title: String
    public var description: String
    
    public init(_ title: String, _ descr: String) {
        self.id = Date()
        self.title = title
        self.description = descr
    }
}
