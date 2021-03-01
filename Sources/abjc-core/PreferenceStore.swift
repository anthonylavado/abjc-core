//
//  PreferenceStore.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation
import Combine
import SwiftUI

public class PreferenceStore: ObservableObject {
    private enum Keys {
        static let watchnowtab = "tabviewconfiguration.watchnowtab"
        static let seriestab = "tabviewconfiguration.seriestab"
        static let moviestab = "tabviewconfiguration.moviestab"
        static let searchtab = "tabviewconfiguration.searchtab"
        
        static let debugMode = "debugmode"
        static let betaflags = "betaflags"
    }

    private let cancellable: Cancellable
    private let defaults: UserDefaults

    public let objectWillChange = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.watchnowtab: false,
            Keys.moviestab: true,
            Keys.seriestab: true,
            Keys.searchtab: true,
            Keys.debugMode: false,
            Keys.betaflags: []
        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    public let version: Version = Version(1,0,0, 13)
    
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
    
    public var isDebugEnabled: Bool {
        get { defaults.bool(forKey: Keys.debugMode) }
        set {
            defaults.setValue(newValue, forKey: Keys.debugMode)
            self.objectWillChange.send()
        }
    }
    
    public var betaflags: Set<BetaFlag> {
        get {
            let data = defaults.object(forKey: Keys.betaflags) as? [String] ?? [String]()
            let flags = data.filter({ BetaFlag(rawValue: $0) != nil }).map({BetaFlag(rawValue: $0)!})
            return Set(flags)
        }
        set {
            defaults.set(newValue.map({ $0.rawValue }), forKey: Keys.betaflags)
            objectWillChange.send()
        }
    }
    
    public var beta_singlePagemode: Bool {
        get {
            betaflags.isEnabled(.singlePageMode)
        }
        set {
            betaflags.set(.singlePageMode, to: newValue)
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
    
    public var beta_playbackContinuation: Bool {
        get {
            betaflags.isEnabled(.playbackContinuation)
        }
        set {
            betaflags.set(.playbackContinuation, to: newValue)
        }
    }
    
    public var beta_uglymode: Bool {
        get {
            betaflags.isEnabled(.uglymode)
        }
        set {
            betaflags.set(.uglymode, to: newValue)
        }
    }
    
    public var beta_showsTitles: Bool {
        get {
            betaflags.isEnabled(.showsTitles)
        }
        set {
            betaflags.set(.showsTitles, to: newValue)
        }
    }
        
    public enum BetaFlag: String, CaseIterable {
        case playbackReporting = "playbackreporting"
        case playbackContinuation = "playbackcontinuation"
        case uglymode = "uglymode"
        case singlePageMode = "singlepagemode"
        case showsTitles = "showstitles"
        
        public var label: LocalizedStringKey {
            return LocalizedStringKey("betaflags."+self.rawValue+".label")
        }
        
        public var description: LocalizedStringKey {
            return LocalizedStringKey("betaflags."+self.rawValue+".descr")
        }
        
        public static func availableFlags() -> [BetaFlag] {
            let config = Self.configuration()
            return Self.allCases.filter({ (config[$0] ?? false) })
        }
        
        public static func configuration() -> [BetaFlag: Bool] {
            return [
                .playbackReporting: false,
                .playbackContinuation: false,
                .uglymode: true,
                .singlePageMode: true,
                .showsTitles: true
            ]
        }
    }
}


public extension Set where Element == PreferenceStore.BetaFlag {
    mutating func enable(_ flag: Element) {
        self.insert(flag)
    }
    
    mutating func disable(_ flag: Element) {
        self.remove(flag)
    }
    
    mutating func toggle(_ flag: Element) {
        if isEnabled(flag) {
            disable(flag)
        } else {
            enable(flag)
        }
    }
    
    mutating func set(_ flag: Element, to state: Bool) {
        if state != isEnabled(flag) {
            toggle(flag)
        }
    }
    
    func isEnabled(_ flag: Element) -> Bool {
        return self.contains(flag)
    }
}
