//
//  BaseVC.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/15/16.
//
//

import Foundation
import AVKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(BaseVC.menuButtonPressed(_:)))
        tapGestureRec.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        view.addGestureRecognizer(tapGestureRec)
    }
    
    func menuButtonPressed(gesture: UITapGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
}