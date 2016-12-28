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

  var posts = [Post]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
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


}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let post = posts[indexPath.row]
    print("STEVEN: \(post.caption)")
    
    return tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCellTableViewCell
  }
  
}
