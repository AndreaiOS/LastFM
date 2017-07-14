//
//  URLSessionNetworkEngine.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

public struct URLSessionEngine: NetworkEngine {
    
    public let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    private func buildUrlRequest(from networkRequest: Request) throws -> URLRequest {
        guard let url = URL(string: finalPath(from: networkRequest)) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpBody = try httpBody(from: networkRequest)
        request.allHTTPHeaderFields = networkRequest.headers
        request.httpMethod = networkRequest.method.rawValue
        
        return request
    }
    
    private func finalPath(from request: Request) -> String {
        switch request.method {
        case .get:
            guard let parameters = request.parameters else {
                return request.path
            }
            
            var pathExtension = ""
            for (key, value) in parameters {
                let connector = pathExtension.isEmpty ? "?" : "&"
                pathExtension.append("\(connector)\(key)=\(value)")
            }
            return "\(request.path)\(pathExtension)"
            
        default:
            return request.path
        }
    }
    
    private func httpBody(from request: Request) throws -> Data? {
        guard let parameters = request.parameters else {
            return nil
        }
        
        guard let body = try? JSONSerialization.data(withJSONObject: request.parameters, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            throw NetworkError.invalidParameters
        }
        
        return body
    }
    
    public func dispatch(request: Request, onSuccess: @escaping (Any) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        do {
            let urlRequest = try buildUrlRequest(from: request)
            let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let error = error {
                    onError(NetworkError.wrongResponse(error))
                    return
                }
                
                guard let _data = data else {
                    onError(NetworkError.emptyResponse)
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) else {
                    onError(NetworkError.invalidResponse)
                    return
                }
                
                onSuccess(json)
            })
            
            dataTask.resume()
            
            return dataTask
        } catch let error {
            onError(error)
            return nil
        }
    }
}
