//
//  ListViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/27/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        //initialize tabBarButton
        super.init(coder: aDecoder)
        self.tabBarItem.image = UIImage(named: "List")
        self.tabBarItem.title = "List"
        self.tabBarItem.tag = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        println("listViewVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
