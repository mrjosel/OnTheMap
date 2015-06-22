//
//  LoginViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var gradient = CAGradientLayer()
    @IBOutlet weak var udacityIconImageView: UIImageView!
    
    let lightOrange = UIColor(red: 1.125, green: 0.625, blue: 0.125, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Udacity Orange Fade
        gradient.frame = view.bounds
        gradient.colors = [lightOrange.CGColor, UIColor.orangeColor().CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        //Udacity Image
        udacityIconImageView.contentMode = UIViewContentMode.ScaleAspectFit
        udacityIconImageView.image = UIImage(named: "Udacity")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

