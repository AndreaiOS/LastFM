//
//  NetworkResponseProcessor.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

/**
 A NetworkResponseProcessor can be used if you want to transform the response in some
 way after being parsed or returned.
 
 Using NetworkResponseProcessor objects, the Client builds a functional pipeline
 in which the response is transformed.
 */
public protocol NetworkResponseProcessor {
    
    /**
     Pure function in which the response gets transformed in some other object
     and then returned.
     */
    func process(response: Any) -> Any
}
