//
//  PlaylistItemsVC.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/13/16.
//
//

import Foundation
import UIKit

class PlaylistItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var selectedItem :Item?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(playlistFinishedLoading),
            name: YoutubePostNotification,
            object: nil)
        
        YoutubeAPI.sharedInstance.getPlaylistItems((selectedItem?.id)!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: YoutubePostNotification, object: nil)
    }
    
    @objc func playlistFinishedLoading(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    //MARK: TableView DataSource/Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if YoutubeAPI.sharedInstance.playlistItems != nil {
            count = YoutubeAPI.sharedInstance.playlistItems.items.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = YoutubeAPI.sharedInstance.playlistItems.items[indexPath.row] as Item
        
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistItemId")
        cell?.textLabel?.text = item.snippet.title
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        let index = context.nextFocusedIndexPath
        let item = YoutubeAPI.sharedInstance.playlistItems.items[index!.row] as Item
        YoutubeAPI.sharedInstance.loadImages(item.snippet.thumbnails.high.url, completion: {
            (result: UIImage) in
                self.imageView.image = result
        })
    }
}
