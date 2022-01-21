//
//  EXURLSession.swift
//  NYTimes
//
//  Created by melaabd on 20/01/2022.
//

import Foundation


//MARK: - URLSession response handlers
extension URLSession: RequestNews {
    
    /// task for fetch data the generic types
    /// - Returns: `URLSessionDataTask`
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, String?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { [weak self] data, response, error in
            
            if let _ = error {
                completionHandler(nil, NetworkResponse.noInternet.rawValue)
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse else {
                completionHandler(nil, NetworkResponse.failed.rawValue)
                return
            }
            
            let networkResponse = self?.parseHTTPResponse(httpURLResponse)
            
            switch networkResponse {
            case .success:
                guard let data = data else {
                    completionHandler(nil, NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(decodedResponse, nil)
                } catch {
                    completionHandler(nil, NetworkResponse.unableToDecode.rawValue)
                }
            default:
                guard let data = data else {
                    completionHandler(nil, networkResponse?.rawValue)
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(decodedResponse, nil)
                } catch {
                    completionHandler(nil, NetworkResponse.unableToDecode.rawValue)
                }
            }
        }
    }
    
}

extension RequestNews where Self: URLSession {
    /// load news data task
    /// - Parameters:
    ///   - url: URL
    ///   - completionHandler: (News?, errorMessage?)
    /// - Returns: URLSessionDataTask
    func newsTask(with url: URL, completionHandler: @escaping (News?, String?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


/// Defines network response status and provides error strings for network request error
enum NetworkResponse: String {
    case success
    case authenticationError    = "Authentication Error"
    case badRequest             = "Bad Request"
    case failed                 = "Network request Failed"
    case noData                 = "No Data Found"
    case unableToDecode         = "Decoding Error"
    case noInternet             = "No Internet Connectivity."
}

// MARK: - URLSession response handlers
extension URLSession {
    
    /// Checks URLResponse statusCode and returns a *NetworkResponse* case depending upon status
    /// - Parameter urlResponse: URLResponse received back from URLTask
    private func parseHTTPResponse(_ urlResponse:HTTPURLResponse) -> NetworkResponse {
        switch urlResponse.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .authenticationError
        case 501...600:
            return .badRequest
        default:
            return .failed
        }
    }
}
