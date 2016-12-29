//
//  FeedViewController.swift
//  SocialMedia
//
//  Created by Steven Yang on 11/22/16.
//  Copyright © 2016 Steven Yang. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var imageAddButton: CircleImageView!
  @IBOutlet weak var captionField: FancyTextField!
  
  
  var posts = [Post]()
  var imagePicker: UIImagePickerController!
  static var imageCache: NSCache<NSString, UIImage> = NSCache()
  var imageSelected = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = true
    imagePicker.delegate = self
    
    DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
      
      if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
        
        for snap in snapshot {
          print("SNAP: \(snap)")
          if let postDict = snap.value as? Dictionary<String, AnyObject> {
            let key = snap.key
            let post = Post(postKey: key, postData: postDict)
            self.posts.append(post)
          }
        }
      }
      self.tableView.reloadData()
    })
  }

  @IBAction func signOutButtonTapped(_ sender: Any) {
    
    let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
    print("STEVEN: ID removed from keychain \(keychainResult)")
    try! FIRAuth.auth()?.signOut()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func addImageButtonTapped(_ sender: Any) {
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func postButtonTapped(_ sender: Any) {

    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
    guard let caption = captionField.text, caption != "" else {
      print("STEVEN: Caption must be entered")
      let alert = UIAlertController(title: "Caption must be entered", message: nil, preferredStyle: .alert)
      alert.addAction(ok)
      present(alert, animated: true, completion: nil)
      return
    }
    
    guard let img = imageAddButton.image, imageSelected == true else {
      print("STEVEN: Image must be selected")
      let alert = UIAlertController(title: "Image must be selected", message: nil, preferredStyle: .alert)
      alert.addAction(ok)
      present(alert, animated: true, completion: nil)
      return
    }
    
    if let imgData = UIImageJPEGRepresentation(img, 0.2) {
      let imageUID = NSUUID().uuidString
      let metaData = FIRStorageMetadata()
      // Turn image into jpeg
      metaData.contentType = "image/jpeg"
      
      DataService.ds.REF_POST_IMAGES.child(imageUID).put(imgData, metadata: metaData) { (metadata, error) in
        if error != nil {
          print("STEVEN: Unable to upload image to Firebase storage")
        } else {
          print("STEVEN: Successfully uploaded image to Firebase storage")
          let downloadURL = metaData.downloadURL()?.absoluteString
        }
      }
    }
    
  }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let post = posts[indexPath.row]
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCellTableViewCell {
            
      if let img = FeedViewController.imageCache.object(forKey: post.imageURL as NSString) {
        
        cell.configureCell(post: post, image: img)
        return cell
      } else {
        
        cell.configureCell(post: post)
        return cell
      }

    } else {
      
      return PostCellTableViewCell()
    }
  }
  
}

extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      imageAddButton.image = image
      imageSelected = true
    } else {
      print("STEVEN: A valid image wasn't selected")
    }
    
    imagePicker.dismiss(animated: true, completion: nil)
  }

}
