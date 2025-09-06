// NetworkService.swift
import Foundation
import Combine

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    case unauthorized
    case rateLimitExceeded
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unauthorized:
            return "Unauthorized - check your API key"
        case .rateLimitExceeded:
            return "Rate limit exceeded - please try again later"
        }
    }
}

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetch<T: Codable>(_ type: T.Type, from url: URL) async throws -> T
    func fetchData(from url: URL) async throws -> Data
}

// MARK: - Network Service Implementation
class NetworkService: NetworkServiceProtocol, ObservableObject {
    static let shared = NetworkService()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func fetch<T: Codable>(_ type: T.Type, from url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError(URLError(.badServerResponse))
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw NetworkError.unauthorized
            case 429:
                throw NetworkError.rateLimitExceeded
            case 400...499:
                throw NetworkError.serverError(httpResponse.statusCode)
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode)
            default:
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            do {
                let decodedData = try decoder.decode(type, from: data)
                return decodedData
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response data: \(jsonString)")
                }
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.serverError(0)
            }
            
            return data
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}



