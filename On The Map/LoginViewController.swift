//
//  LoginViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var udacityIconImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var topvView: UIView!
    
    //vars and lets
    let lightOrange = UIColor(red: 1.125, green: 0.625, blue: 0.125, alpha: 1.0)
    var gradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Configure the UI
        self.configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureUI() {
        //Udacity Orange Fade
        gradient.frame = view.bounds
        gradient.colors = [lightOrange.CGColor, UIColor.orangeColor().CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        topvView.backgroundColor = UIColor.clearColor()
        
        //Udacity Image
        udacityIconImageView.contentMode = UIViewContentMode.ScaleAspectFill
        udacityIconImageView.image = UIImage(named: "Udacity")
        
        //Login Label
        loginLabel.textAlignment = NSTextAlignment.Center
        loginLabel.font = UIFont(name: "Roboto-Thin", size: 30.0)
        loginLabel.textColor = UIColor.whiteColor()
        loginLabel.text = "Login to Udacity"
    }

}

