//
//  MusicRecord.swift
//  przegladarka_plyt
//
//  Created by Avasil on 24/10/2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import Foundation

class MusicRecord: NSObject, NSCoding {

    let artist: String
    let album: String
    let genre: String
    let year: Int
    let tracks: Int
    
    init(_ artist: String, _ album: String, _ genre: String, _ year: Int, _ tracks: Int) {
        
        self.artist = artist
        self.album = album
        self.genre = genre
        self.year = year
        self.tracks = tracks
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let artist = decoder.decodeObject(forKey: "artist") as? String,
            let album = decoder.decodeObject(forKey: "album") as? String,
            let genre = decoder.decodeObject(forKey: "genre") as? String,
            let year = decoder.decodeObject(forKey: "year") as? Int,
            let tracks = decoder.decodeObject(forKey: "tracks") as? Int
            else { return nil }
        
        self.init(artist, album, genre, year, tracks)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.artist, forKey: "artist")
        aCoder.encode(self.album, forKey: "album")
        aCoder.encode(self.genre, forKey: "genre")
        aCoder.encodeCInt(Int32(self.year), forKey: "year")
        aCoder.encodeCInt(Int32(self.tracks), forKey: "tracks")
    }
}
