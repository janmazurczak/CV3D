//
//  DefaultExplorationFlow.swift
//  CV3D
//
//  Created by Jan Mazurczak on 17/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import Foundation

class DefaultExplorationFlow: ExplorationFlow {
    func requestData(for presenter: Presenter) {
        let cachedCV =
            CV(contentsOf: .cvCache) ??                 // Check what's stored already
            CV(version: -1, root: .text("Loading..."))  // Create a placeholder if nothing is stored
        presenter.present(cachedCV)
        Configuration.current.communicator.fetch(CV.self, at: ["getCV"]) { [weak presenter] in
            guard let cv = $0 else { return }
            try? JSONEncoder().encode(cv).write(to: .cvCache)   // Store what's downloaded
            guard cv.version > cachedCV.version else { return } // Don't refresh if there is no newer version
            presenter?.present(cv)
        }
    }
}

extension CV {
    init?(contentsOf url: URL) {
        guard
            let data = try? Data(contentsOf: url),
            let cv = try? JSONDecoder().decode(CV.self, from: data)
            else { return nil }
         self = cv
    }
}

extension URL {
    static let cvCache: URL = cache.appendingPathComponent("cv.json", isDirectory: false)
    static let cache: URL = {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CV3DCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }()
}

