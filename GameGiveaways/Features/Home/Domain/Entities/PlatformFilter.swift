//
//  PlatformFilter.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

enum PlatformFilter: Equatable {
    
    case all
    case specific(PlatformEntity)
    
    static func == (lhs: PlatformFilter, rhs: PlatformFilter) -> Bool {
        switch (lhs, rhs) {
        case (.all, .all):
            return true
            
        case (.specific(let lhsValue), .specific(let rhsValue)):
            return lhsValue == rhsValue
            
        default:
            return false
        }
    }
}
