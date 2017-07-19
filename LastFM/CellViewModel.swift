//
//  CellViewModel.swift
//  LastFM
//
//  Created by Andrea Murru on 17/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import UIKit

struct CellViewModel: CellRepresentable {
    
    var text: String
    var accessoryType: UITableViewCellAccessoryType
    
//    init(song: Song?) {
//        text = song?.name ?? ""
//        accessoryType = UITableViewCellAccessoryType.none
//    }
    
    init(artist: Artist?) {
        text = artist?.name ?? ""
        accessoryType = UITableViewCellAccessoryType.none
    }
    
//    init(album: Album?) {
//        text = album?.name ?? ""
//        accessoryType = UITableViewCellAccessoryType.none
//    }
}
