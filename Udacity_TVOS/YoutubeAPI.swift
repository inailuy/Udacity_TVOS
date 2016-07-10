//
//  YoutubeAPI.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/8/16.
//
//

import Foundation

let baseURL = "https://www.googleapis.com/youtube/v3/"
let urlString = "playlists?part=snippet&maxResults=50"
let channelId = "&channelId=UCBVCi5JbYmfG3q5MEuoWdOw"
let APIkey = "&key=AIzaSyBV2lTiVQqrpoxkUdgCtQ7utwRVwjgNFTg"

let YoutubePostNotification = "simpleGetDone"

class YoutubeAPI {
    static let sharedInstance = YoutubeAPI()
    var playlist: Playlist!
    
    func getPlaylistModel() {
        let string = baseURL + urlString + channelId + APIkey
        let url = NSURL(string: string)

       let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, reponse, error) in
            print("Task completed")
            // rest of the function...
            if error == nil {
                do {
                    let jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    self.playlist = Playlist(dictionary: jsonResults as! NSDictionary)
                    NSNotificationCenter.defaultCenter().postNotificationName(YoutubePostNotification, object: nil)
                } catch {
                    // failure
                    print("Fetch failed: \((error as NSError).localizedDescription)")
                }
            }
        })
        
        task.resume()
    }
}