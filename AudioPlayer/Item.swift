//
//  Item.swift
//  AudioPlayer
//
//  Created by Nathan Christensen on 2024-02-21.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
