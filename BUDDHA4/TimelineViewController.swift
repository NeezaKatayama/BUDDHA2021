//
//  TimelineViewController.swift
//  BUDDHA
//
//  Created by 片山義仁 on 2019/12/11.
//  Copyright © 2019 Neeza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Kingfisher



class TimelineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    var giveData: Post!
    var feelingNumber: Int!
    var feelingType: FeelingType!
    let Color = UIColor(named: "customColor")
    var actUser = 1
    var ref: DatabaseReference!
    
   

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postChoicedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
      let url = URL(string: postChoicedArray[indexPath.row].imageURL)
        cell.imageView.kf.setImage(with: url)
          cell.backgroundColor = Color
     
      return cell
       
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
              let cellSize:CGFloat = self.view.bounds.width/4
             
              return CGSize(width: cellSize, height: cellSize)
    }
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var imageButoon: UIButton!
    @IBOutlet var feelingChoiceButton: UIButton!
    @IBOutlet weak var personSwitch: UISwitch!
    
  
    var postArray: [Post] = []
    var postChoicedArray: [Post] = []
    var imageNameArray = [String]()
    var selectedImage: UIImage!
    var auth: Auth!
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        personSwitch.tintColor = UIColor.darkGray    /// OFFの場合の縁取りの色
        personSwitch.backgroundColor = UIColor.lightGray    /// OFFの場合の背景色
        personSwitch.layer.cornerRadius =  personSwitch.frame.size.height / 2
        personSwitch.onTintColor = UIColor.white

        ref = Database.database().reference()//リアル
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = Color
        self.view.backgroundColor = Color
      
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        auth = Auth.auth()
        
    }
  
       
   
   @IBAction func tapped(_ sender: UISwitch) {
        if sender.isOn {
           actUser = 1
            
           
                self.postChoicedArray = []
            
            for post in self.postArray {
                
                if post.feelingType.rawValue == self.feelingNumber {
                    self.postChoicedArray.append(post)
                    
                } else if self.feelingNumber == nil {
                    self.postChoicedArray.append(post)
                }
                
                
            }
                self.collectionView.reloadData()
        } else {
           actUser = 2
            self.postChoicedArray = []
            
            for post in self.postArray {
                
                if post.feelingType.rawValue == self.feelingNumber && post.userID == self.auth.currentUser!.uid{
                    self.postChoicedArray.append(post)
                    
                }
                else if self.feelingNumber == nil && post.userID == self.auth.currentUser!.uid {
                    self.postChoicedArray.append(post)
                }
                
                
                
            }
            self.collectionView.reloadData()
        }
    
    }
    
    @IBAction func didTapButton() {
            
            self.performSegue(withIdentifier: "toSeparate", sender: self)
            }
        
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
                
        self.ref.child("posts").queryOrdered(byChild: "updatedAt").observe(.value) { snapshot in
            
            self.postArray = []
            self.postChoicedArray = []
               
                for child in snapshot.children {
                    let data = (child as! DataSnapshot).value
                    let post = Post(data: data as! [String : Any])
                    
                    self.postArray.append(post)
                     if self.actUser == 2 && post.feelingType.rawValue == self.feelingNumber &&  post.userID == self.auth.currentUser!.uid{
                        self.postChoicedArray.append(post)
                       
                        
                    }
                    else if self.actUser == 1 && post.feelingType.rawValue == self.feelingNumber {
                        self.postChoicedArray.append(post)
                    }
                    else if self.feelingNumber  == nil {
                        self.postChoicedArray.append(post)
                    }
                    
                }
            
            
            
                self.collectionView.reloadData()
                
                
            }
            
            
            
        }
    
    
  
      
        
    
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            giveData = postArray[indexPath.row]
        
        
           
               performSegue(withIdentifier: "toDetail",sender: nil)
          
        
       
       }
    
   
     
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toDetail" {
               let vc = segue.destination as! DetailViewController
               vc.receiveData = giveData

               
           } else if segue.identifier == "toSeparate" {
            let vc2 = segue.destination as! SeparateViewController1
            vc2.choiceFunc = {(feelingNumber: Int) -> Void in
                self.postChoicedArray = []
                
                self.feelingNumber = feelingNumber
                
            for post in self.postArray {
                
                if post.feelingType.rawValue == self.feelingNumber {
                    self.postChoicedArray.append(post)
                    
                }
                
                
            }
                self.collectionView.reloadData()
           }
            
        
       }
     }
    
    
    
    
  
        
    
    
    
    
    
    
    // Do any additional setup after loading the view.
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


  
