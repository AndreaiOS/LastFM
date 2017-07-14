//
//  MainViewModel.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

enum MainSection: Int {
    case Artist, Album, Song
    
    static var count = {
        return MainSection.Song.rawValue
    }
    
    static let sectionTitles = [
        Artist: "Artist",
        Album: "Album",
        Song: "Song"
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = MainSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
    
}


struct Song: NetworkJSONDecodable {
    var name = ""
    var artist = ""
    var image = ""
    
    init() {}
    
    static func instantiate(withJSON json: [String : Any]) -> Song? {
        
        var songObject = Song()
        
        songObject.name = (json["name"] as? String) ?? ""
        songObject.artist = (json["artist"] as? String) ?? ""
        songObject.image = (json["image"] as? String) ?? ""
        
        return songObject
    }
}

struct GetSongByTitle: Request {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var path: String { return "\(baseURL)?method=track.search&track=\(title)&api_key=0145fb1a1f3717841e09a006b830dbba&format=json" }
    
    var method: HTTPMethod = .get
}


class MainViewModel {
    let client = NetworkClient()
    
    let request = GetSongByTitle(title: "Belive")

    var array = [Song]()

    func startTest(completion: @escaping (_ result: Bool) -> Void) {
        client
            .requestArray(of: Song.self,
                               request: request,
                               onSuccess: { song in
                                self.array = song

                                completion(true)
            },
                               onError: { error in
                                print("Something went wrong.")
                                completion(false)
            }
        )
    }
}
