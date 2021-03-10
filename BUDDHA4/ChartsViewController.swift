//
//  ChartsViewController.swift
//  BUDDHA
//
//  Created by 片山義仁 on 2020/09/01.
//  Copyright © 2020 Neeza. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseAuth

class ChartsViewController: UIViewController {
    @IBOutlet var pieChartsView: PieChartView!
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
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!
    var logoImageView: UIImageView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        ref = Database.database().reference()//リアル
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
        
        pieChartsView.legend.enabled = false
        pieChartsView.chartDescription?.enabled = false
        pieChartsView.highlightPerTapEnabled = false
        pieChartsView.rotationEnabled = true
        pieChartsView.holeColor = Color
        pieChartsView.entryLabelFont = NSUIFont(name: "HelveticaNeue", size: 35.0)
        //pieChartsView.transparentCircleColor = NSUIColor(white: 1.0, alpha: 105.0/255.0)
        pieChartsView.drawHoleEnabled = true
        
        //imageView作成
        self.logoImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 204, height: 204))
                //画面centerに
                self.logoImageView.center = self.view.center
                //logo設定
                self.logoImageView.image = UIImage(named: "launchyou3")
                //viewに追加
                self.view.addSubview(self.logoImageView)
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
            self.ref.child("posts").observe(.value) { snapshot in //データ解消済
                
                    self.postArray = []
                for child in snapshot.children {
                    let data = (child as! DataSnapshot).value
                   
                    let post = Post(data: data as! [String : Any])
          
                        let date: Date = post.createdAt!//降順
                        let now : Date = Date()
                                                
                                                
                        let elapsedDays = Calendar.current.dateComponents([.day], from: date, to: now).day//投稿日で分ける、降順
                        if elapsedDays! <= 1 {
                            
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
                        
        
    }
                    
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
        
               //少し縮小するアニメーション
            UIView.animate(withDuration: 0.3,
                           delay: 0.5,
                   options: UIView.AnimationOptions.curveEaseOut,
                   animations: { () in
                    self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                   }, completion: { (Bool) in

               })

               //拡大させて、消えるアニメーション
            UIView.animate(withDuration: 0.2,
                           delay: 0.8,
                   options: UIView.AnimationOptions.curveEaseOut,
                   animations: { () in
                    self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                       self.logoImageView.alpha = 0
                   }, completion: { (Bool) in
                       self.logoImageView.removeFromSuperview()
               })
           }     
    
    override func viewWillDisappear(_ animated: Bool) {
       Auth.auth().removeStateDidChangeListener(handle!)
        
    }

    
    
                
                
                
                
                
                
                
                
                
        @IBAction func actionSegmentedControl(_ sender: UISegmentedControl) {
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
                
                
             
              
                
                
                self.ref.child("posts").observe(.value) { snapshot in//データ解消
                    
                   
                        self.postArray = []
                        feelingNumberOfHappy = 0
                        feelingNumberOfLove = 0
                        feelingNumberOfAngry = 0
                        feelingNumberOfFunny = 0
                        feelingNumberOfSad = 0
                        feelingNumberOfEnvy = 0
                        feelingNumberOfSurprise = 0
                        feelingNumberOfNothing = 0

                        for child in snapshot.children {
                            let data = (child as! DataSnapshot).value
                            let post = Post(data: data as! [String : Any])
                            let date: Date = post.createdAt!
                            let now : Date = Date()
                                                    
                                                    
                            let elapsedDays = Calendar.current.dateComponents([.day], from: date, to: now).day
                                                  
                            
                            
                            switch sender.selectedSegmentIndex {
                            case 0:
                                
                  
                            if elapsedDays! <= 1 {
                               
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
                            
                            
                            
                            
                        }
                            case 1:
                                
                                
                                if elapsedDays! <= 7 {
                                   
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
                                
                                
                                
                                
                            }
                            case 2:
                                
                                if elapsedDays! <= 30 {
                                    
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
                                
                                
                                
                                
                            }
                           
                        
                        
                            default: break
                                
                            }
                    }
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
        
        
        
        
        
        
        
      
    
    
   
    
    

  

            
