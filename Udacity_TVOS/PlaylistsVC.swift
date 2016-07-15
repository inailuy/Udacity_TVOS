//
//  PlaylistsVC.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/8/16.
//
//

import UIKit

class PlaylistsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let defaultFrameImg = CGRectMake(40, 0, 560, 300)
    let focusFrameImg = CGRectMake(0, 0, 640, 360)
    let defaultFrameLabel = CGRectMake(40, 315, 560, 30)
    let focusFrameLabel = CGRectMake(0, 0, 560, 30)
    
    var selectedIndexPath :NSIndexPath?
    
    enum Tag :Int {
        case ImageView = 100
        case Label = 101
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Udacity Course Catalog"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(playlistFinishedLoading),
            name: YoutubePostNotification,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func playlistFinishedLoading(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "PresentPlayerItems" {
            let vc = segue.destinationViewController as! PlaylistItemsVC
            vc.selectedItem = YoutubeAPI.sharedInstance.playlist.items[(selectedIndexPath?.row)!] as Item
        }
    }
    //MARK: CollectionView DataSource/Delegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = YoutubeAPI.sharedInstance.playlist.items[indexPath.row] as Item
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("id", forIndexPath: indexPath)
        let imgView = cell.viewWithTag(Tag.ImageView.rawValue) as! UIImageView
        let label = cell.viewWithTag(Tag.Label.rawValue) as! UILabel
        
        label.text = item.snippet.title
        YoutubeAPI.sharedInstance.loadImages(item.snippet.thumbnails.medium.url) {
            (result: UIImage) in
                imgView.image = result
        }
        
        if cell.gestureRecognizers?.count == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(PlaylistsVC.collectionCellTapped(_:)))
            tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
            cell.addGestureRecognizer(tap)
        }
        
        return cell
    }
    
    func collectionCellTapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? UICollectionViewCell {
            selectedIndexPath = collectionView.indexPathForCell(cell)
            performSegueWithIdentifier("PresentPlayerItems", sender: nil)
        }
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
            let imgView = prev.viewWithTag(Tag.ImageView.rawValue) as? UIImageView
            let label = prev.viewWithTag(Tag.Label.rawValue) as? UILabel
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                imgView?.frame = self.defaultFrameImg//TODO:crashing bug
                label?.frame = self.defaultFrameLabel
            })
        }
        
        if let next = context.nextFocusedView {
            let imgView = next.viewWithTag(Tag.ImageView.rawValue) as? UIImageView
            let label = next.viewWithTag(Tag.Label.rawValue) as? UILabel
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                imgView?.frame = self.focusFrameImg
                label?.frame = self.defaultFrameLabel
            })
        }
    }
    
    //MARK: UIScrollViewDelegate 
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //getting the scroll offset
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height && YoutubeAPI.sharedInstance.playlist != nil {
            //we are at the bottom
            YoutubeAPI.sharedInstance.getNextPlaylistModel()
        }
    }
}