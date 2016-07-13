//
//  PlaylistsVC.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/8/16.
//
//

import UIKit

class PlaylistsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let defaultFrame = CGRectMake(40, 0, 560, 300)
    let focusFrame = CGRectMake(0, 0, 640, 360)
    
    enum Tag :Int {
        case ImageView = 100
        case Label = 101
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(playlistFinishedLoading),
            name: YoutubePostNotification,
            object: nil)
    }
    
    @objc func playlistFinishedLoading(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = YoutubeAPI.sharedInstance.playlist.items[indexPath.row] as Item
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("id", forIndexPath: indexPath)
        let imgView = cell.viewWithTag(Tag.ImageView.rawValue) as! UIImageView
        let label = cell.viewWithTag(Tag.Label.rawValue) as! UILabel
        
        label.text = item.snippet.title
        YoutubeAPI.sharedInstance.loadImages(item.snippet.thumbnails.medium.url) {
            (result: UIImage) in
            dispatch_async(dispatch_get_main_queue(), {
                imgView.image = result
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if YoutubeAPI.sharedInstance.playlist != nil {
            count = YoutubeAPI.sharedInstance.playlist.items.count
        }
        return count
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let prev = context.previouslyFocusedView {
            let imgView = prev.viewWithTag(Tag.ImageView.rawValue) as! UIImageView
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                imgView.frame = self.defaultFrame
            })
        }
        
        if let next = context.nextFocusedView {
            let imgView = next.viewWithTag(Tag.ImageView.rawValue) as! UIImageView
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                imgView.frame = self.focusFrame
            })
        }
    }
}