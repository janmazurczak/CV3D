//
//  StandardBackendCommunicator.swift
//  CV3D
//
//  Created by Jan Mazurczak on 18/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import Foundation

class StandardBackendCommunicator: BackendCommunicator {
    let endpoint: URL
    private let queue: OperationQueue
    init(at endpoint: URL) {
        self.endpoint = endpoint
        self.queue = OperationQueue()
    }
    func fetch<Result>(_ resultType: Result.Type, at path: [String], completion: @escaping (Result?) -> Void) where Result : Decodable {
        let url = path.reduce(endpoint) { $0.appendingPathComponent($1) }
        queue.addOperation {
            var result: Result?
            defer {
                OperationQueue.main.addOperation {
                    completion(result)
                }
            }
            guard let data = try? Data(contentsOf: url) else { return }
            result = try? JSONDecoder().decode(Result.self, from: data)
        }
    }
}
