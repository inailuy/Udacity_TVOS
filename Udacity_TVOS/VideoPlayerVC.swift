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
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = avPlayer
        
        addChildViewController(playerViewController)
        view.addSubview(playerViewController.view)
        playerViewController.didMoveToParentViewController(self)

        avPlayer.play()
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerVC.menuButtonPressed(_:)))
        tapGestureRec.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        view.addGestureRecognizer(tapGestureRec)
    }
    
    func menuButtonPressed(gesture: UITapGestureRecognizer) {
            navigationController?.popViewControllerAnimated(true)
    }
}