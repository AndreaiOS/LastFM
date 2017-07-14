//
//  NetworkPlugin.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

/**
 A Network plugin can define methods that are called during the
 Request life cycle.
 */
public protocol NetworkPlugin {
    /**
     didSendRequest is called after the Request has been dispatched.
     */
    func didSendRequest(_ request: Request)
    
    /**
     didReceiveResponse is called after the response comes and has been validated.
     */
    func didReceiveResponse(_ response: Any, from request: Request)
}

// MARK: - Default implementations -
public extension NetworkPlugin {
    func didSendRequest(_ request: Request) {}
    func didReceiveResponse(_ response: Any, from request: Request) {}
}
