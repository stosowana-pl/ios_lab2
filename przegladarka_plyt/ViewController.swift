//
//  ViewController.swift
//  przegladarka_plyt
//
//  Created by Użytkownik Gość on 10.10.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var musicRecords = [MusicRecord]()
    var currentRecord: Int = 0
    
    func getTotalNumber() -> Int {
        return musicRecords.count
    }
    
    func getMaxIndex() -> Int {
        return musicRecords.count - 1
    }
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var NewRecord: UIButton!
    
    @IBOutlet weak var RemoveRecord: UIButton!
    
    @IBOutlet weak var PreviousRecord: UIButton!
    
    @IBOutlet weak var NextRecord: UIButton!
    
    @IBOutlet weak var ArtistField: UITextField!
    
    @IBOutlet weak var TitleField: UITextField!
    
    @IBOutlet weak var GenreField: UITextField!
    
    @IBOutlet weak var YearField: UITextField!
    
    @IBOutlet weak var TracksField: UITextField!
    
    @IBOutlet weak var RecordXY: UILabel!
    
    @IBAction func SaveClicked(_ sender: UIButton) {
    }
    
    @IBAction func NewRecordClicked(_ sender: UIButton) {
        self.currentRecord = self.getMaxIndex() + 1
        
        let artist = ArtistField.text ?? ""
        let title = TitleField.text ?? ""
        let genre = GenreField.text ?? ""
        let year = Int(YearField.text ?? "") ?? 0
        let tracks = Int(TracksField.text ?? "") ?? 0
        
        let newRecord = MusicRecord(artist, title, genre, year, tracks)
        
        self.musicRecords.append(newRecord)
        
        self.updateView()
    }
    
    @IBAction func RemoveRecordClicked(_ sender: UIButton) {
        self.musicRecords.remove(at: self.currentRecord)
        self.updateView()
    }
    
    @IBAction func PreviousRecordClicked(_ sender: UIButton) {
        self.currentRecord -= 1
        self.updateView()
    }
    
    @IBAction func NextRecordClicked(_ sender: UIButton) {
        self.currentRecord += 1
        self.updateView()
    }
    
    
    func parseJson(_ json: [String: Any]) -> MusicRecord? {
        guard let artist = json["artist"] as? String,
        let album = json["album"] as? String,
        let genre = json["genre"] as? String,
        let year = json["year"] as? Int,
        let tracks = json["tracks"] as? Int
            else {
                return nil
        }
        return MusicRecord(artist, album, genre, year, tracks)
    }
    
    func requestData() {
        let session = URLSession.shared
        let url = URL.init(string: "https://isebi.net/albums.php")
        
        session.dataTask(with: url!, completionHandler: { (maybeData: Data?, _, _) in
            if let data = maybeData,
            let maybeJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                let json = maybeJson {
                for singleRecord in json {
                    if let newRecord = self.parseJson(singleRecord){
                        self.musicRecords.append(newRecord)
                    }
                }
            }
            DispatchQueue.main.async {
                self.updateView()
            }
    }).resume()
    }
    
    func updateView(){
        // turned off when we are at first record
        self.PreviousRecord.isEnabled = self.currentRecord > 0
        // turned off when we are at last record
        self.NextRecord.isEnabled = self.currentRecord <= self.getMaxIndex()
        // can't remove non existing record
        self.RemoveRecord.isEnabled = self.currentRecord <= self.getMaxIndex()
        // we can only save if we are operating on last index
        self.SaveButton.isEnabled = self.currentRecord == self.getMaxIndex()
        // disable new record button if we are already createing new one
        self.NewRecord.isEnabled = self.currentRecord < self.getMaxIndex()
        
        if(self.currentRecord <= self.getMaxIndex()){
            self.existingRecordView()
        } else {
            self.newRecordView()
        }
    }
    
    func existingRecordView(){
        let currentRecord = self.musicRecords[self.currentRecord]
        
        self.ArtistField.text = currentRecord.artist
        self.TitleField.text = currentRecord.album
        self.GenreField.text = currentRecord.genre
        self.YearField.text = String(currentRecord.year)
        self.TracksField.text = String(currentRecord.tracks)
        
        self.RecordXY.text = "Rekord \(self.currentRecord + 1) z \(self.getTotalNumber())"
    }
    
    func newRecordView(){
        self.ArtistField.text = ""
        self.TitleField.text = ""
        self.GenreField.text = ""
        self.YearField.text = ""
        self.TracksField.text = ""
        
        self.RecordXY.text = "Nowy Rekord"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
