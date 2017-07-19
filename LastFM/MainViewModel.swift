//
//  MainViewModel.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

//enum MainSection: Int {
//    case Artist, Album, Song
//    
//    static var count = {
//        return 3
//    }
//    
//    static let sectionTitles = [
//        Artist: "Artist",
//        Album: "Album",
//        Song: "Song"
//    ]
//    
//    func sectionTitle() -> String {
//        if let sectionTitle = MainSection.sectionTitles[self] {
//            return sectionTitle
//        } else {
//            return ""
//        }
//    }
//    
//}

struct ArtistSection {
    var header: String
    var artists: [Item]
    
    var updated: Date
    
    init(header: String, artists: [Item], updated: Date) {
        self.header = header
        self.artists = artists
        self.updated = updated
    }
}

extension ArtistSection : AnimatableSectionModelType {
    typealias Item = Artist
    typealias Identity = String

    var identity: String {
        return header
    }
    
    var items: [Item] {
        return artists
    }
    
    init(original: ArtistSection, items: [Item]) {
        self = original
        self.artists = items
    }
}

extension ArtistSection
: CustomDebugStringConvertible {
    var debugDescription: String {
        let interval = updated.timeIntervalSince1970
        let numbersDescription = artists.map { "\n\($0.name)" }.joined(separator: "")
        return "NumberSection(header: \"\(self.header)\", numbers: \(numbersDescription)\n, updated: \(interval))"
    }
}

extension Artist
    : IdentifiableType
, Equatable {
    typealias Identity = String
    
    var identity: String {
        return name
    }
}

// equatable, this is needed to detect changes
func == (lhs: Artist, rhs: Artist) -> Bool {
    return lhs.name == rhs.name && lhs.date == rhs.date
}

// MARK: Some nice extensions
extension Artist
: CustomDebugStringConvertible {
    var debugDescription: String {
        return "IntItem(number: \(name), date: \(date.timeIntervalSince1970))"
    }
}

extension Artist
: CustomStringConvertible {
    
    var description: String {
        return "\(name)"
    }
}

extension ArtistSection: Equatable {
    
}

func == (lhs: ArtistSection, rhs: ArtistSection) -> Bool {
    return lhs.header == rhs.header && lhs.items == rhs.items && lhs.updated == rhs.updated
}

struct Artist: NetworkJSONDecodable {
    var name = ""
    var artist = ""
    var image = ""
    var date = Date()

    static func instantiate(withJSON json: [String : Any]) -> Artist? {
        
        var artistObject = Artist()
        
        artistObject.name = (json["name"] as? String) ?? ""
        artistObject.artist = (json["artist"] as? String) ?? ""
        artistObject.image = (json["image"] as? String) ?? ""
        artistObject.date = Date()
        return artistObject
    }
}

//struct Artist: NetworkJSONDecodable {
//    var name = ""
//    var artist = ""
//    var image = ""
//    
//    init() {}
//    
//    static func instantiate(withJSON json: [String : Any]) -> Artist? {
//        
//        var songObject = Artist()
//        
//        songObject.name = (json["name"] as? String) ?? ""
//        songObject.artist = (json["artist"] as? String) ?? ""
//        songObject.image = (json["image"] as? String) ?? ""
//        
//        return songObject
//    }
//}

//struct Album: NetworkJSONDecodable {
//    var name = ""
//    var artist = ""
//    var image = ""
//    
//    init() {}
//    
//    static func instantiate(withJSON json: [String : Any]) -> Album? {
//        
//        var songObject = Album()
//        
//        songObject.name = (json["name"] as? String) ?? ""
//        songObject.artist = (json["artist"] as? String) ?? ""
//        songObject.image = (json["image"] as? String) ?? ""
//        
//        return songObject
//    }
//}

//struct Song: NetworkJSONDecodable {
//    var name = ""
//    var artist = ""
//    var image = ""
//    
//    init() {}
//    
//    static func instantiate(withJSON json: [String : Any]) -> Song? {
//        
//        var songObject = Song()
//        
//        songObject.name = (json["name"] as? String) ?? ""
//        songObject.artist = (json["artist"] as? String) ?? ""
//        songObject.image = (json["image"] as? String) ?? ""
//        
//        return songObject
//    }
//}

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
    var dataSource: RxTableViewSectionedAnimatedDataSource<ArtistSection>?

    var artistArray = [Artist]()
//    var albumArray: [Album] = []
//    var songArray: [Song] = []
    
    var sections = Variable([
        ArtistSection(header: "First section", artists: [], updated: Date()),
        ArtistSection(header: "Second section", artists: [], updated: Date())
    ])

    func startTest(text: String) {
//        let songRequest = GetSongByTitle(title: text)
//        let albumRequest = GetAlbumByTitle(title: text)
        let artistRequest = GetArtistByName(name: text)
        

        client.requestArtistArray(of: Artist.self,
                                  request: artistRequest,
                                  onSuccess: { (artist) in
                                    self.artistArray = artist
                                    var sections = self.sections
                                    self.sections.value = [ArtistSection(original: sections.value[0], items: artist), sections.value[1]]
                                    

        }) { error in
            
        }
    }
}

