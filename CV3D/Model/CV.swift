//
//  CV.swift
//  CV3D
//
//  Created by Jan Mazurczak on 17/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import Foundation

struct CV: Codable {
    let root: CVBranch
}

struct CVBlock: Codable {
    let title: String
    let items: [CVBranch]
}

enum CVBranch {
    case block([CVBlock])
    case text(String)
    case url(URL)
    case appStoreItem(String)
}

extension CVBranch: Codable {
    enum CodingKeys: CodingKey {
        case block
        case text
        case url
        case appStoreItem
    }
    enum DecodingError: String, Error {
        case unknownBranchType
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .block(let value):
            try container.encode(value, forKey: .block)
        case .text(let value):
            try container.encode(value, forKey: .text)
        case .url(let value):
            try container.encode(value, forKey: .url)
        case .appStoreItem(let value):
            try container.encode(value, forKey: .appStoreItem)
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode([CVBlock].self, forKey: .block) {
            self = .block(value)
            return
        }
        if let value = try? container.decode(String.self, forKey: .text) {
            self = .text(value)
            return
        }
        if let value = try? container.decode(URL.self, forKey: .url) {
            self = .url(value)
            return
        }
        if let value = try? container.decode(String.self, forKey: .appStoreItem) {
            self = .appStoreItem(value)
            return
        }
        throw DecodingError.unknownBranchType
    }
}
