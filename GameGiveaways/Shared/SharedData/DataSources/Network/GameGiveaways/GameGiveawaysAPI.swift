//
//  GameGiveawaysAPI.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Moya
import Foundation

enum GameGiveawaysAPI {
    case getAllGiveaways
    case getGiveawaysByPlatform(platform: String)
}

extension GameGiveawaysAPI: TargetType {
    var baseURL: URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "https://www.gamerpower.com/api")!
    }

    var path: String {
        return "/giveaways"
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .getAllGiveaways:
            return .requestPlain
            
        case .getGiveawaysByPlatform(let platform):
            return .requestParameters(parameters: ["platform": platform], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
