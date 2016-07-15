//
//  VideoPlayerVC.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/13/16.
//
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class VideoPlayerVC: AVPlayerViewController {
    var item :Item!
    var index :Int!
    var avPlayer :AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        createTapGestures()
        
        playWithVideoId((item.snippet.resourceId?.videoId)!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(VideoPlayerVC.audioStateChanged), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    func createTapGestures() {
        let tapMenuGestureRec = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerVC.menuButtonPressed(_:)))
        tapMenuGestureRec.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        view.addGestureRecognizer(tapMenuGestureRec)
        
        let tapPlayGestureRec = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerVC.playButtonPressed(_:)))
        tapPlayGestureRec.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        view.addGestureRecognizer(tapPlayGestureRec)
    }
    
    func menuButtonPressed(gesture: UITapGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func playButtonPressed(gesture: UITapGestureRecognizer) {
        avPlayer.rate == 0 ? avPlayer.play() : avPlayer.pause()
    }
    
    func audioStateChanged() {
        let playlistItemArray = YoutubeAPI.sharedInstance.playlistItems.items
        if index != playlistItemArray.count {
            index = index + 1
            item = playlistItemArray[index]
            playWithVideoId(item.snippet.resourceId!.videoId)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func playWithVideoId(videoId :String) {
        SVProgressHUD.show()
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let youTubeString : String = "https://www.youtube.com/watch?v=" + (self.item.snippet.resourceId?.videoId)!
            let videos : NSDictionary = HCYoutubeParser.h264videosWithYoutubeURL(NSURL(string: youTubeString))
            let urlString : String = videos["medium"] as! String//hd720
            let asset = AVAsset(URL: NSURL(string: urlString)!)
            dispatch_async(dispatch_get_main_queue(), {
                let avPlayerItem = AVPlayerItem(asset:asset)
                self.avPlayer = AVPlayer(playerItem: avPlayerItem)
                let avPlayerLayer  = AVPlayerLayer(player: self.avPlayer)
                avPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
                self.view.layer.addSublayer(avPlayerLayer)
                
                let playerViewController = AVPlayerViewController()
                playerViewController.player = self.avPlayer
                
                self.addChildViewController(playerViewController)
                self.view.addSubview(playerViewController.view)
                playerViewController.didMoveToParentViewController(self)
                
                self.avPlayer.play()
                SVProgressHUD.dismiss()
            })
        }
    }
}