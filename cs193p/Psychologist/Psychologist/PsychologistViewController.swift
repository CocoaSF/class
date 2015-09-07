//
//  ViewController.swift
//  Psychologist
//
//  Created by sbx_fc on 15/9/7.
//  Copyright (c) 2015年 SF. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {
    
    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("showNothing", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        
        if let hvc = destination as? HappinessViewController{
            if let identifier = segue.identifier{
                switch identifier{
                case "showSad": hvc.happiness = 0
                case "showNothing": hvc.happiness = 25
                case "showHappy": hvc.happiness = 100
                default: hvc.happiness = 50
                }
            }
        }
    }


}

