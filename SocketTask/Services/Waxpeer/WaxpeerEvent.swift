//
//  WaxpeerEvent.swift
//  SocketTask
//
//  Created by Tim Nazar on 4/16/24.
//

import Foundation

enum WaxpeerEvent: Codable {
    private static let kCSGo = "csgo"
    private static let kNew = "new"
    private static let kRemoved = "removed"
    private static let kUpdate = "update"

    case csgo
    case new
    case removed
    case update
    case unknown(String)

    init(raw: String) {
        switch raw {
        case Self.kCSGo: self = .csgo
        case Self.kNew: self = .new
        case Self.kRemoved: self = .removed
        case Self.kUpdate: self = .update
        default: self = .unknown(raw)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = WaxpeerEvent(raw: try container.decode(String.self))
    }

    var raw: String {
        switch self {
        case .csgo: return Self.kCSGo
        case .new: return Self.kNew
        case .removed: return Self.kRemoved
        case .update: return Self.kUpdate
        case .unknown(let raw): return raw
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.raw)
    }
}

extension WaxpeerEvent: Equatable {
    static func == (lhs: WaxpeerEvent, rhs: WaxpeerEvent) -> Bool {
        switch (lhs, rhs) {
        case (.csgo, .csgo),
             (.new, .new),
             (.removed, .removed),
             (.update, .update):
            return true

        case (let .unknown(lhsCode), let .unknown(rhsCode)):
            return lhsCode == rhsCode

        default:
            return false
        }
    }
}
