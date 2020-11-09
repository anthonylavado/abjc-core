//
//  PreferenceStore.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation
import Combine

public class PreferenceStore: ObservableObject {
    private enum Keys {
        static let watchnowtab = "tabviewconfiguration.watchnowtab"
        static let seriestab = "tabviewconfiguration.seriestab"
        static let moviestab = "tabviewconfiguration.moviestab"
        static let searchtab = "tabviewconfiguration.searchtab"
        
        static let debugOptions = "debugoptions"
        
        static let betaflags = "betaflags"
    }

    private let cancellable: Cancellable
    private let defaults: UserDefaults

    public let objectWillChange = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Keys.watchnowtab: true,
            Keys.moviestab: true,
            Keys.seriestab: true,
            Keys.searchtab: true,
            Keys.debugOptions: true,
            Keys.betaflags: []
        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    public var showingWatchNowTab: Bool {
        get { defaults.bool(forKey: Keys.watchnowtab) }
        set { defaults.setValue(newValue, forKey: Keys.watchnowtab) }
    }
    
    public var showingMoviesTab: Bool {
        get { defaults.bool(forKey: Keys.moviestab) }
        set { defaults.setValue(newValue, forKey: Keys.moviestab) }
    }
    
    public var showingSeriesTab: Bool {
        get { defaults.bool(forKey: Keys.seriestab) }
        set { defaults.setValue(newValue, forKey: Keys.seriestab) }
    }
    
    public var showingSearchTab: Bool {
        get { defaults.bool(forKey: Keys.searchtab) }
        set { defaults.setValue(newValue, forKey: Keys.searchtab) }
    }
    
    
    
    public var betaflags: Set<BetaFlag> {
        get {
            let data = defaults.object(forKey: Keys.betaflags) as? [String] ?? [String]()
            let flags = data.filter({ BetaFlag(rawValue: $0) != nil }).map({BetaFlag(rawValue: $0)!})
            return Set(flags)
        }
        set {
            defaults.set(newValue.map({ $0.rawValue }), forKey: Keys.betaflags)
        }
    }
    
    public var beta_playbackReporting: Bool {
        get {
            betaflags.isEnabled(.playbackReporting)
        }
        set {
            betaflags.set(.playbackReporting, to: newValue)
        }
    }
        
    public enum BetaFlag: String, CaseIterable {
        case playbackReporting = "playbackreporting"
        
        public func availableFlags() -> [BetaFlag] {
            let config = Self.configuration()
            return Self.allCases.filter({ (config[$0] ?? false) })
        }
        
        static func configuration() -> [BetaFlag: Bool]{
            return [
                Self.playbackReporting: false
            ]
        }
    }
}


extension Set where Element == PreferenceStore.BetaFlag {
    mutating func enable(_ flag: Element) {
        if !self.contains(flag) {
            self.insert(flag)
        }
    }
    
    mutating func disable(_ flag: Element) {
        if self.contains(flag) {
            self.remove(flag)
        }
    }
    
    mutating func set(_ flag: Element, to state: Bool) {
        if state != isEnabled(flag) {
            if state {
                enable(flag)
            } else {
               disable(flag)
            }
        }
    }
    
    func isEnabled(_ flag: Element) -> Bool {
        return self.contains(flag)
    }
}
