//
//  CV.swift
//  CV3D
//
//  Created by Jan Mazurczak on 17/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import Foundation

struct CV: Codable {
    let version: Int
    let root: CVBlock
}

struct CVBlock: Codable {
    let title: String
    let items: [CVBranch]
}

enum CVBranch {
    case block(CVBlock)
    case text(String)
    case link(Link)
    case mail(Mail)
    case appStoreLink(AppStoreLink)
}

struct Link: Codable {
    let name: String
    let url: URL
}

struct Mail: Codable {
    let name: String
    let mail: String
    let subject: String
}

struct AppStoreLink: Codable {
    let name: String
    let itemID: String
}

extension CVBranch: Codable {
    enum CodingKeys: CodingKey {
        case block
        case text
        case link
        case mail
        case appStoreLink
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
        case .link(let value):
            try container.encode(value, forKey: .link)
        case .mail(let value):
            try container.encode(value, forKey: .mail)
        case .appStoreLink(let value):
            try container.encode(value, forKey: .appStoreLink)
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(CVBlock.self, forKey: .block) {
            self = .block(value)
            return
        }
        if let value = try? container.decode(String.self, forKey: .text) {
            self = .text(value)
            return
        }
        if let value = try? container.decode(Link.self, forKey: .link) {
            self = .link(value)
            return
        }
        if let value = try? container.decode(Mail.self, forKey: .mail) {
            self = .mail(value)
            return
        }
        if let value = try? container.decode(AppStoreLink.self, forKey: .appStoreLink) {
            self = .appStoreLink(value)
            return
        }
        throw DecodingError.unknownBranchType
    }
}
