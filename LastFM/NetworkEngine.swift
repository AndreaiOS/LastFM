//
//  NetworkEngine.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

/**
 NetworkEngine contains the necessary logic to dispatch a request and getting a JSON result from it.
 */
public protocol NetworkEngine {
    /**
     Dispatches a Request and returns a URLSessionDataTask, so it can be cancelled at any time.
     
     - parameter request: a Request to be dispatched
     - parameter onSuccess: a callback that get called when everything worked fine.
     - parameter onError: a callback that get called when something went wrong.
     - returns the URLSessionTask, because it assumes that you use URLSession at some point.
     */
    func dispatch(request: Request, onSuccess: @escaping (Any) -> Void, onError: @escaping  (Error) -> Void) -> URLSessionDataTask?
}
