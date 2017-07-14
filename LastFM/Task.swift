//
//  Task.swift
//  LastFM
//
//  Created by Andrea Murru on 13/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation
import RxSwift

class Task<Input, Output> {
    func perform(_ element: Input) -> Observable<Output> {
        fatalError("This must be implemented in subclasses")
    }
}
