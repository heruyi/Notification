//
//  ViewController.swift
//  Notification
//
//  Created by henry on 2016/9/27.
//  Copyright © 2016年 何如意. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.notification.sendNotification(.UIApplicationDidEnterBackground, userInfo: ["obser":self])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

