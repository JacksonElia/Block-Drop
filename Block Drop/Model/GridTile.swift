//
//  GridTile.swift
//  Block Drop
//
//  Created by Jack Elia on 8/7/22.
//

import Foundation
import SwiftUI

struct GridTile: Codable {
    
    var tileNumber: Int
    var tileFrame: CGRect
    var isBeingHovered = false
    var isExtraPoints = false
    
}
