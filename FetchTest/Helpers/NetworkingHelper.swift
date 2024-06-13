//
//  URLsessionHelper.swift
//  FetchTest
//
//  Created by Brian King on 6/12/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidData
}

extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await self.data(for: request, delegate: nil)
        return (data, response)
    }
}
