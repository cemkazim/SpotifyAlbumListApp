//
//  Future+Extensions.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 07/02/2022.
//

import Combine

extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            if #available(iOS 15.0, *) {
                Task {
                    do {
                        let output = try await operation()
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
