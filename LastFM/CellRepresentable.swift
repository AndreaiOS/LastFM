//
//  CellRepresentable.swift
//  LastFM
//
//  Created by Andrea Murru on 17/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    
    var text: String { get }
    var accessoryType: UITableViewCellAccessoryType { get }
    
}
