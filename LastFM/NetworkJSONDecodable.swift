//
//  NetworkJSONDecodable.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

/**
 A protocol that transforms JSON objects to parsed objects.
 */
public protocol NetworkJSONDecodable {
    static func instantiate(withJSON json: [String: Any]) -> Self?
}
