//
//  PlayerStore.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import Foundation
import Combine
import AVKit
import JellyKit

public class PlayerStore: ObservableObject {
    @Published public var playItem: PlayItem? = nil
    @Published public var api: API? = nil
    public var statusObserver: NSKeyValueObservation? = nil
    public var errorObserver: NSKeyValueObservation? = nil
    
    private var timer: Timer? = nil
    
    public init() {}
    
    /// Prepares Playback for Item
    /// - Parameter episode: Episode Item
    public func play(_ episode: API.Models.Episode) {
        print("PLAYING", episode.name, episode.index ?? 0, episode.id)
        self.playItem = PlayItem(episode)
    }
    
    
    /// Prepares Playback for Item
    /// - Parameter movie: Movie Item
    public func play(_ movie: API.Models.Movie) {
        self.playItem = PlayItem(movie)
    }
    
    
    /// Reports Playback started to Jellyfin server
    /// - Parameter player: AVPlayer
    public func startedPlayback(_ player: AVPlayer?) {
        self.api?.startPlayback(for: self.playItem!.id, at: 0)
    }
    
    
    /// Reports playback progress to Jellyfin Server
    /// - Parameters:
    ///   - player: AVPlayer
    ///   - pos: Playback position in seconds
    public func reportPlayback(_ player: AVPlayer?, _ pos: Double) {
        if let item = playItem {
            self.api?.reportPlayback(for: item.id, positionTicks: Int(pos*1000000))
        }
    }
    
    
    /// Reports playback has stopped to jellyfin server
    /// - Parameters:
    ///   - item: PlayItem
    ///   - player: AVPlayer
    public func stoppedPlayback(_ item: PlayItem, _ player: AVPlayer?) {
        if let playbackPosition = player?.currentTime().seconds {
            let posTicks = Int(playbackPosition * 1000000)
            self.api?.stopPlayback(for: item.id, positionTicks: posTicks)
        } else {
            print("ERROR")
        }
    }
}


public extension PlayerStore {
    class PlayItem: Identifiable {
        public let id: String
        public let sourceId: String
        private let userData: API.Models.UserData
        
        public init(_ item: Playable) {
            self.id = item.id
            self.sourceId = item.mediaSources.first?.id ?? ""
            self.userData = item.userData
        }
    }
}
