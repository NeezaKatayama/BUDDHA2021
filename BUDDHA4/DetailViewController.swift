//
//  DetailViewController.swift
//  BUDDHA
//
//  Created by 片山義仁 on 2020/08/26.
//  Copyright © 2020 Neeza. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth


class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var receiveData: Post!
    var ref: DatabaseReference!
    var auth: Auth!
    
    @IBOutlet var describe: UILabel?
    @IBOutlet var label: UILabel!
    @IBOutlet var delete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let url = URL(string: receiveData.imageURL)
        imageView.kf.setImage(with: url)
       
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        auth = Auth.auth()
        
        self.describe?.text = receiveData.content
        
        self.imageView.layer.cornerRadius = 30
        
        
        switch receiveData.feelingType.rawValue  {
        case 0 :
            label.text = "😊"
        case 1 :
            label.text = "😍"
        case 2 :
            label.text = "😡"
        case 3 :
            label.text = "🤣"
        case 4 :
            label.text = "😰"
        case 5 :
            label.text = "😒"
        case 6 :
            label.text = "😲"
        case 7 :
            label.text = "😑"
        default:
            break
            
        }
        /*self.database.collection("posts").document("receiveData.postID").delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }*/

    }
    
  
    @IBAction override func delete(_ sender: Any?) {
        if receiveData.userID == self.auth.currentUser!.uid {
        let alert: UIAlertController = UIAlertController(title: "投稿を削除", message:  "", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            
            
            self.ref.child("posts").child(self.receiveData.postID).removeValue()
            
            //データ解消済　
            self.navigationController?.popViewController(animated: true)
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            
        })

        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        //実際にAlertを表示する
            present(alert, animated: true, completion: nil)
            
        } else {
            delete.isHidden = true
            }
   
    }
    
  
        
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
