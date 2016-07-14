//
//  YoutubeAPI.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/8/16.
//
//

import Foundation
import UIKit

let baseURL = "https://www.googleapis.com/youtube/v3/"
let playlistItemsSuffix = "playlistItems?"
let playlistSuffix = "playlists?"
let suffixParameters = "part=snippet&maxResults=50"
let channelId = "&channelId=UCBVCi5JbYmfG3q5MEuoWdOw"
let APIkey = "&key=AIzaSyBV2lTiVQqrpoxkUdgCtQ7utwRVwjgNFTg"

let YoutubePostNotification = "fetchedAllPlaylists"

class YoutubeAPI {
    static let sharedInstance = YoutubeAPI()
    var playlist: Playlist!
    var playlistItems: Playlist!
    var imageDictionary = NSMutableDictionary()
    
    func getPlaylistModel() {
        let string = baseURL + playlistSuffix + suffixParameters + channelId + APIkey
        let url = NSURL(string: string)

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, reponse, error) in
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
    
    func getPlaylistItems(playlistId: String) {
        let urlString = baseURL + playlistItemsSuffix + suffixParameters + "&playlistId=" + playlistId + APIkey
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, reponse, error) in
            if error == nil {
                do {
                    let jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    self.playlistItems = Playlist(dictionary: jsonResults as! NSDictionary)
                    NSNotificationCenter.defaultCenter().postNotificationName(YoutubePostNotification, object: nil)
                    print(jsonResults)
                } catch {
                    // failure
                    print("Fetch failed: \((error as NSError).localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    func loadImages(inputURL: String, completion: (result: UIImage) -> Void) {
        if let img = imageDictionary[inputURL] { // check if image already exists
            completion(result: img as! UIImage)
        } else {
            let imgUrl = NSURL(string: inputURL)
            let task = NSURLSession.sharedSession().dataTaskWithURL(imgUrl!, completionHandler: {(data, reponse, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.imageDictionary.setValue(img, forKey: inputURL)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(result: img!)
                    })
                }
            })
            task.resume()
        }
    }
}