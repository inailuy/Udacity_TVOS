//
//  ViewController.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/8/16.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(action),
            name: YoutubePostNotification,
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func action(notification: NSNotification){
        //do stuff
        print(YoutubeAPI.sharedInstance.playlist)
        
    }
}

