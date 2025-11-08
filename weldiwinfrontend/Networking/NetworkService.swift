//
//  NetworkService.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 3/11/2025.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    // ✅ FIXED: Added HTTP error checking (was missing!)
    func postRequest<T: Codable>(to endpoint: Endpoint, body: T, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            // ✅ ADD HTTP ERROR CHECKING (like GET and PATCH have)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let message = String(data: data, encoding: .utf8) ?? "Request failed"
                completion(.failure(NSError(domain: "NetworkService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // GET request with authentication token
    func getRequest(to endpoint: Endpoint, token: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let message = String(data: data, encoding: .utf8) ?? "Request failed"
                completion(.failure(NSError(domain: "NetworkService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // PATCH request with authentication token (for updates)
    func patchRequest<T: Codable>(to endpoint: Endpoint, body: T, token: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let message = String(data: data, encoding: .utf8) ?? "Request failed"
                completion(.failure(NSError(domain: "NetworkService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // ✅ POST request with authentication token (for creating children, etc.)
    func postRequestWithAuth<T: Codable>(to endpoint: Endpoint, body: T, token: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let message = String(data: data, encoding: .utf8) ?? "Request failed"
                completion(.failure(NSError(domain: "NetworkService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
