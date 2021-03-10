//
//  AddViewController.swift
//  BUDDHA
//
//  Created by 片山義仁 on 2020/01/13.
//  Copyright © 2020 Neeza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    @IBOutlet var feelingLabel: UILabel!
    @IBOutlet var feelingButton: UIButton!
  
    
    var image: UIImage!
    var feelingNumber: Int!
    var auth: Auth!
    var ref: DatabaseReference!
    
    
    
  


 override func viewDidLoad() {
  
        super.viewDidLoad()
        auth = Auth.auth()
       showImagePicker() //imagepicker出すか出さないか。
    
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    self.imageView.layer.cornerRadius = 30
    self.contentTextView.layer.cornerRadius = 17
    self.contentTextView.layer.borderWidth = 1.5// 枠線の幅
    self.contentTextView.layer.borderColor = UIColor.black.cgColor    // 枠線の色
    self.contentTextView.delegate = self
   
        let toolBar = UIToolbar() // キーボードの上に置くツールバーの生成
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // 今回は、右端にDoneボタンを置きたいので、左に空白を入れる
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard)) // Doneボタン
        toolBar.items = [flexibleSpaceBarButton, doneButton] // ツールバーにボタンを配置
        toolBar.sizeToFit()
        contentTextView.inputAccessoryView = toolBar // テキストビューにツールバーをセット
        
    
    }
    
    
    //メソッド：showimagepicker
    func showImagePicker() {
        //pickercontrollerを宣言
        let pickerController = UIImagePickerController()
        //photolibraryないから画像をとる
        pickerController.sourceType = .photoLibrary
       
        pickerController.delegate = self
        //pickercontrollerが現れる
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func showSimpleAlert(title: String, message: String) {
        //アラートの型的な物の宣言
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //アラートを出す
        present(alertController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = (info[.originalImage] as! UIImage)
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    func labelLoad() {
        switch self.feelingNumber {
        case 0 :
            feelingLabel.text = "😊"
            
        case 1 :
            feelingLabel.text = "😍"
            
        case 2 :
           feelingLabel.text = "😡"
         
        case 3 :
            feelingLabel.text = "🤣"
        
        case 4 :
            feelingLabel.text = "😰"
            
        case 5 :
            feelingLabel.text = "😒"
           
        case 6 :
            feelingLabel.text = "😲"
           
        case 7 :
            feelingLabel.text = "😑"
           
        default:
            break
            
        }
        
    }
    //写真変更
    @IBAction func touchUpInsideChangeButton() {
        //メソッド：showimagepicker
        showImagePicker()
    }
    @IBAction func didTapButton() {
            
            self.performSegue(withIdentifier: "toChoice", sender: self)
            }
    @IBAction func postContent() {
        
        ref = Database.database().reference()
        guard let key = ref.child("posts").childByAutoId().key else { return }
        let content = contentTextView.text!
        let saveDocument = self.ref.child("posts").child(key)
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        if  image == nil {
            showSimpleAlert(title: "画像が選択されていません", message: "画像を選択してください。")
            return
        }
            
            
            if self.feelingNumber == nil {
        showSimpleAlert(title: "感情が選択されていません", message: "感情を選択してください。")
                
            } else {
                 let data = image.jpegData(compressionQuality: 0.3)!
                 let storage = Storage.storage()
                 let storageRef = storage.reference()
                 //let imageName = saveDocument.documentID + ".jpeg"
                 let imageName = key + ".jpeg"
                 var imagesRef = storageRef.child(imageName)
                 _ = imagesRef.putData(data, metadata: nil) { (metadata, error) in //返り値を使ってない
                     guard let metadata = metadata else {
                         return
                     }
                     
                     imagesRef.downloadURL { (url, error) in
                         guard let downloadURL = url else {
                             return
                         }
                         
                         saveDocument.setValue([
                             "content": content,
                             "postID": key,
                             "createdAt": ServerValue.timestamp(),
                             "updatedAt": -1*Int(timeInterval),
                             "ImageURL": downloadURL.absoluteString,
                             "FeelingType": self.feelingNumber,
                             "userID":  self.auth.currentUser?.uid
                         ]) { (error:Error?, ref:DatabaseReference) in                        if error == nil {
                            let UINavigationController = self.tabBarController?.viewControllers?[0];
                            self.tabBarController?.selectedViewController = UINavigationController;                            //遷移
                            } else {
                                 print(error!)
                             }
                         }
                         
                     }
                     
                 }
                 button.isEnabled = false
               
                
            }
        
    }
    
    
   
   
   
    
   
    @objc func dismissKeyboard(_ textField: UITextField) -> Bool {
           // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toChoice" {
           let vc2 = segue.destination as! ChoiceViewController
           vc2.choiceFunc = {(feelingNumber: Int) -> Void in
            self.feelingNumber = feelingNumber
            self.labelLoad()
           }
           
            
         }
    }
    
    
    
    
}
