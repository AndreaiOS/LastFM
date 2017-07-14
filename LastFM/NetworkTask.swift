//
//  NetworkTask.swift
//  LastFM
//
//  Created by Andrea Murru on 13/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation
import RxSwift

class NetworkTask<Input: Request, Output>: Task<Input, Output> {
    let dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }
    
    override func perform(_ element: Input) -> Observable<Output> {
        fatalError("This must be implemented in subclasses")
    }
}
