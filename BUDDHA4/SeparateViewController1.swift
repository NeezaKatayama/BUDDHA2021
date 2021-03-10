//
//  ViewController.swift
//  BUDDHA
//
//  Created by 片山義仁 on 2019/11/20.
//  Copyright © 2019 Neeza. All rights reserved.
//

import UIKit
import Firebase

class SeparateViewController1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    var feelingNumber: Int!
    var choiceFunc: ((Int) -> Void)!
    
    
    @IBOutlet var happyButton: UIButton!
    @IBOutlet var loveButton: UIButton!
    @IBOutlet var angryButton: UIButton!
    @IBOutlet var funnyButton: UIButton!
    @IBOutlet var sadButton: UIButton!
    @IBOutlet var envyButton: UIButton!
    @IBOutlet var surpriseButton: UIButton!
    @IBOutlet var nothingButton: UIButton!
    
    
    
    
    
    @IBAction func viewFeelingpostViewController(sender: UIButton) {
        feelingNumber = sender.tag
        
       
        choiceFunc(feelingNumber)
     
       // performSegue(withIdentifier: "toTimeline", sender: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimeline" {
            let nextViewController = segue.destination as! TimelineViewController
            nextViewController.feelingNumber = self.feelingNumber
          
        }
        
        
    }*/
    
    
    
    
    
}

