//
//  Item.swift
//  TestApp
//
//  Created by Leon  on 09.10.25.
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
