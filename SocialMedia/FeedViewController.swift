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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  @IBAction func signOutButtonTapped(_ sender: Any) {
    
    let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
    print("STEVEN: ID removed from keychain \(keychainResult)")
    try! FIRAuth.auth()?.signOut()
    dismiss(animated: true, completion: nil)
  }


}
