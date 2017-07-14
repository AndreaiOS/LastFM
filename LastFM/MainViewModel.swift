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
        return 3
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

struct Artist: NetworkJSONDecodable {
    var name = ""
    var artist = ""
    var image = ""
    
    init() {}
    
    static func instantiate(withJSON json: [String : Any]) -> Artist? {
        
        var songObject = Artist()
        
        songObject.name = (json["name"] as? String) ?? ""
        songObject.artist = (json["artist"] as? String) ?? ""
        songObject.image = (json["image"] as? String) ?? ""
        
        return songObject
    }
}

struct Album: NetworkJSONDecodable {
    var name = ""
    var artist = ""
    var image = ""
    
    init() {}
    
    static func instantiate(withJSON json: [String : Any]) -> Album? {
        
        var songObject = Album()
        
        songObject.name = (json["name"] as? String) ?? ""
        songObject.artist = (json["artist"] as? String) ?? ""
        songObject.image = (json["image"] as? String) ?? ""
        
        return songObject
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

struct GetArtistByName: Request {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    var path: String { return "\(baseURL)?method=artist.search&artist=\(name)&api_key=0145fb1a1f3717841e09a006b830dbba&format=json" }
    
    var method: HTTPMethod = .get
}

struct GetAlbumByTitle: Request {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var path: String { return "\(baseURL)?method=album.search&album=\(title)&api_key=0145fb1a1f3717841e09a006b830dbba&format=json" }
    
    var method: HTTPMethod = .get
}


class MainViewModel {
    let client = NetworkClient()
    
    var artistArray = [Artist]()
    var albumArray = [Album]()
    var songArray = [Song]()

    func startTest(text: String, completion: @escaping (_ result: Bool) -> Void) {
        let songRequest = GetSongByTitle(title: text)
        let albumRequest = GetAlbumByTitle(title: text)
        let artistRequest = GetArtistByName(name: text)

        client
            .requestSongArray(of: Song.self,
                               request: songRequest,
                               onSuccess: { song in
                                self.songArray = song

//                                completion(true)
            },
                               onError: { error in
                                print("Something went wrong.")
                                completion(false)
            }
        )
        
        client
            .requestAlbumArray(of: Album.self,
                          request: albumRequest,
                          onSuccess: { album in
                            self.albumArray = album
                            
//                            completion(true)
            },
                          onError: { error in
                            print("Something went wrong.")
//                            completion(false)
            }
        )
        
        client
            .requestArtistArray(of: Artist.self,
                          request: artistRequest,
                          onSuccess: { artist in
                            self.artistArray = artist
                            
                            completion(true)
            },
                          onError: { error in
                            print("Something went wrong.")
//                            completion(false)
            }
        )
    }
}
