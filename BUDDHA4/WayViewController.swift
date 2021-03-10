//
//  WayViewController.swift
//  BUDDHA
//
//  Created by 片山義仁 on 2020/09/01.
//  Copyright © 2020 Neeza. All rights reserved.
//

import UIKit
import Charts
import FirebaseAuth
import Firebase

class WayViewController: UIViewController {
    @IBOutlet var pieChartsView: PieChartView!
    @IBOutlet var helpButton: UIButton!
    var feelingNumberOfHappy: Int = 0
    var feelingNumberOfLove: Int = 0
    var feelingNumberOfAngry: Int = 0
    var feelingNumberOfFunny: Int = 0
    var feelingNumberOfSad: Int = 0
    var feelingNumberOfEnvy: Int = 0
    var feelingNumberOfSurprise: Int = 0
    var feelingNumberOfNothing: Int = 0
    var auth: Auth!
    var postArray: [Post] = []
    let Color = UIColor(named: "customColor")
    let pieColor = [UIColor.init(hex: "262626"), UIColor.init(hex: "FFFFFF")] 
    var handle: AuthStateDidChangeListenerHandle!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        ref = Database.database().reference()//リアル
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
        
                
            
            
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        handle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
        if auth.currentUser == nil {
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        } else {
            self.pieChartsView.legend.enabled = false
            self.pieChartsView.chartDescription?.enabled = false
            self.pieChartsView.highlightPerTapEnabled = false
            self.pieChartsView.rotationEnabled = true
            self.pieChartsView.holeColor = self.Color
            
            self.pieChartsView.entryLabelFont = NSUIFont(name: "HelveticaNeue", size: 35.0)
            //pieChartsView.transparentCircleColor = NSUIColor(white: 1.0, alpha: 105.0/255.0)
            self.pieChartsView.drawHoleEnabled = true
            
            
         
          
            self.ref.child("posts").observe(.value) { snapshot in //データ解消済、大元
                
               
                    self.postArray = []
                for child in snapshot.children {
                    let data = (child as! DataSnapshot).value
                   
                    let post = Post(data: data as! [String : Any])

                     
                        
                        switch post.feelingType.rawValue  {
                        case 0 :
                            self.feelingNumberOfHappy = self.feelingNumberOfHappy + 1
                        case 1 :
                            self.feelingNumberOfLove = self.feelingNumberOfLove + 1
                        case 2 :
                            self.feelingNumberOfAngry = self.feelingNumberOfAngry + 1
                        case 3 :
                            self.feelingNumberOfFunny = self.feelingNumberOfFunny + 1
                        case 4 :
                            self.feelingNumberOfSad = self.feelingNumberOfSad + 1
                        case 5 :
                            self.feelingNumberOfEnvy = self.feelingNumberOfEnvy + 1
                        case 6 :
                            self.feelingNumberOfSurprise = self.feelingNumberOfSurprise + 1
                        case 7 :
                            self.feelingNumberOfNothing = self.feelingNumberOfNothing + 1
                        default:
                            break
            
                        
                    }
                        //データを反えい
                    
                }
    
                
                let dataEntries = [
                    PieChartDataEntry(value: Double(self.feelingNumberOfHappy),
                                          label: "😊"),
                    PieChartDataEntry(value: Double(self.feelingNumberOfLove),
                                          label: "😍"),
                    PieChartDataEntry(value: Double(self.feelingNumberOfAngry),
                                          label: "😡"),
                    PieChartDataEntry(value: Double(self.feelingNumberOfFunny),
                                          label: "🤣"),
                    PieChartDataEntry(value: Double(self.feelingNumberOfSad),
                                          label: "😰"),
                    PieChartDataEntry(value: Double(self.feelingNumberOfEnvy),
                                          label: "😒"),
                    PieChartDataEntry(value: Double(self.feelingNumberOfSurprise),
                                          label: "😲"),
                    PieChartDataEntry(value: Double(self.feelingNumberOfNothing),
                                          label: "😑")
                    ]
                    let dataSet = PieChartDataSet(entries: dataEntries, label: "feeling")
                    
                dataSet.colors = self.pieColor
                    
                    dataSet.valueTextColor = UIColor.black
                    
                    dataSet.entryLabelColor = UIColor.black
                dataSet.drawValuesEnabled = false
                
                    self.pieChartsView.data = PieChartData(dataSet: dataSet)
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .percent
                    formatter.maximumFractionDigits = 1
                    formatter.multiplier = 1.0
                    self.pieChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
                    self.pieChartsView.usePercentValuesEnabled = true
                    
                    
                 
                    
                    
                    
                }

            
        }
        }
            
            
        

    }
    
        
        
        
        
 
    
   /* @IBOutlet var toChoiceViewController: UIButton!
    @IBOutlet var toSeparateViewController: UIButton!
    @IBOutlet var toChartsViewController: UIButton!*/
    
    
    /*@IBAction func toChoiceViewControllertapped() {
        performSegue(withIdentifier: "toChoice", sender: nil)
    }
    @IBAction func toSeparateViewControllertapped() {
        performSegue(withIdentifier: "toPerson", sender: nil)
    }
    
    @IBAction func toChartsViewControllertapped() {
        performSegue(withIdentifier: "toCharts", sender: nil)
        
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
       Auth.auth().removeStateDidChangeListener(handle!)
        
    }
    
    
    
    
    
}
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
