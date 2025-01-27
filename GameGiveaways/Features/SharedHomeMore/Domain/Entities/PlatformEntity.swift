//
//  PlatformEntity.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Foundation

struct PlatformEntity: Identifiable, Equatable {
    var id = UUID().uuidString
    let displayName: String
    let name: String
}
