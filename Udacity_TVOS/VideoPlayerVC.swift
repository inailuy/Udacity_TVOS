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

class VideoPlayerVC: UIViewController {
    var videoId :String!

    override func viewDidLoad() {
        let youTubeString : String = "https://www.youtube.com/watch?v=" + videoId
        let videos : NSDictionary = HCYoutubeParser.h264videosWithYoutubeURL(NSURL(string: youTubeString))
        let urlString : String = videos["medium"] as! String
        let asset = AVAsset(URL: NSURL(string: urlString)!)
        
        let avPlayerItem = AVPlayerItem(asset:asset)
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let avPlayerLayer  = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
        self.view.layer.addSublayer(avPlayerLayer)
        avPlayer.play()
    }
}