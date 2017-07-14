//
//  Request.swift
//  LastFM
//
//  Created by Andrea Murru on 13/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get, post, put, patch, delete
}

public let baseURL = "http://ws.audioscrobbler.com/2.0/"

/**
 Request is the request protocol that your requests has to implement
 in order to be dispatched by the Client via NetworkEngine
 */
public protocol Request {
    var requestPlugins: [NetworkPlugin] { get }

    var requestResponseProcessors: [NetworkResponseProcessor] { get }
    var requestResponseValidators: [NetworkResponseValidator] { get }
    
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

// MARK: - Default implementations -
public extension Request {
    var requestPlugins: [NetworkPlugin] { return [] }

    var requestResponseProcessors: [NetworkResponseProcessor] { return [] }
    var requestResponseValidators: [NetworkResponseValidator] { return [] }
    
    var method: HTTPMethod { return .get }
    var parameters: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
}
