//
//  NetworkDispatcher.swift
//  LastFM
//
//  Created by Andrea Murru on 13/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkDispatcher {
    func execute(request: Request) -> Observable<Any>
}
