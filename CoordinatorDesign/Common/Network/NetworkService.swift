//
//  NetworkService.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import Foundation
import SwiftUI

enum APIError: LocalizedError {
    case invalidURL
    case noInternet
    case timeout
    case server
    case unknown
    case invalidResponse(statusCode: Int)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternet:
            return "Please check your internet connection."
        case .timeout:
            return "The request took too long. Try again."
        case .server:
            return "We’re having trouble right now."
        case .unknown:
            return "Something went wrong. Please try again."
        case .invalidResponse(let statusCode):
            return "Request failed with status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode the response."
        }
    }
}


protocol DataService {
    func fetchRequest<T: Decodable>(url: String) async throws -> T
}

protocol ImageServiceProtocol {
    func fetchImage(url: String) async throws -> UIImage
}

final class ImageService: ImageServiceProtocol {
    func fetchImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw APIError.invalidURL //URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw APIError.server //URLError(.badServerResponse)
        }
        return image
    }
}


final class APIService: DataService {
    func fetchRequest<T>(url: String) async throws -> T where T : Decodable {
        guard let url = URL(string: url) else {
            throw APIError.invalidURL //URLError(.badURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResp = response as? HTTPURLResponse else {
                throw APIError.server //URLError(.badServerResponse)
            }
            
            guard 200..<300 ~= httpResp.statusCode else {
                throw APIError.invalidResponse(statusCode: httpResp.statusCode) //URLError(.init(rawValue: httpResp.statusCode))
            }
            
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                return results
            } catch {
                throw APIError.decodingError //URLError(.cannotParseResponse)
            }
        } catch {
            throw APIError.noInternet //URLError(.badServerResponse)
        }
    }
}
