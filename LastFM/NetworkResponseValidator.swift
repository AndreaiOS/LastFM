//
//  NetworkResponseValidator.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

/**
 NetworkResponseValidator validates if a response is correct or not.
 If it isn't correct, then an Error is thrown.
 */
public protocol NetworkResponseValidator {
    func validate(response: Any) throws
}
