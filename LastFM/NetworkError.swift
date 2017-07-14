//
//  NetworkError.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

/**
 An enum with the errors that may happen
 when building the URLRequest or when
 dispatching that request with a Client
 */
public enum NetworkError: Error {
    /**
     If the URL can't be built, the Request
     will throw this error.
     */
    case invalidURL
    
    /**
     If the json body can't be build, the Request
     will throw this error.
     */
    case invalidParameters
    
    /**
     If the response comes with an error, that error will be wrapped
     in this error case.
     */
    case wrongResponse(Error)
    
    /**
     It's thrown if the response comes with no data.
     */
    case emptyResponse
    
    /**
     Is thrown if the response can't be deserialized to a json object.
     */
    case invalidResponse
    
    /**
     Is thrown if the response can't be parsed to the type passed by parameter.
     */
    case invalidParsing
}
