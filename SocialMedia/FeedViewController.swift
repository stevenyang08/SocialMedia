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
  
  var posts = [Post]()
  var imagePicker: UIImagePickerController!
  static var imageCache: NSCache<NSString, UIImage> = NSCache()
  
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
  

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
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
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      imageAddButton.image = image
    } else {
      print("STEVEN: A valid image wasn't selected")
    }
    
    imagePicker.dismiss(animated: true, completion: nil)
  }
  
  
  
  
}
