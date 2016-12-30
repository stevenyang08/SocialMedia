//
//  SignInViewController.swift
//  SocialMedia
//
//  Created by Steven Yang on 11/18/16.
//  Copyright © 2016 Steven Yang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

  @IBOutlet weak var emailTextField: FancyTextField!
  @IBOutlet weak var passwordTextField: FancyTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
      
      performSegue(withIdentifier: "goToFeed", sender: nil)
    }
  }

  @IBAction func facebookButtonTapped(_ sender: Any) {
    
    let facebookLogin = FBSDKLoginManager()
    facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
      
      if error != nil {
        print("STEVEN: Unable to authenticate with Facebook - \(error)")
      } else if result?.isCancelled == true {
        print("STEVEN: User cancelled Facebook authentication")
      } else {
        print("STEVEN: Successfully authenticated with Facebook")
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        self.firebaseAuthenticate(credential)
      }
    }
  }
  
  func firebaseAuthenticate(_ credential: FIRAuthCredential) {
    
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
      
      if error != nil {
        print("STEVEN: Unable to authenticate with Firebase - \(error)")
      } else {
        print("STEVEN: Successfully authenticate with Firebase")
        if let user = user {
          let userData = ["provider": credential.provider]
          self.completeSignin(id: user.uid, userData: userData)
        }
      }
    })
  }
    
  @IBAction func signinButtonTapped(_ sender: Any) {
    
    if let email = emailTextField.text, let password = passwordTextField.text {
      
      FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
        
        if error == nil {
          print("STEVEN: Email user authenticate with Firebase")
          if let user = user {
            let userData = ["provider": user.providerID]
            self.completeSignin(id: user.uid, userData: userData)
          }
        } else {
          
          print("User doesn't exist")
          FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
              
              print("STEVEN: Unable to authenticate with Firebase using email")
            } else {
              
              print("STEVEN: Successfully authenticated with Firebase")
              if let user = user {
                let userData = ["provider": user.providerID]
                self.completeSignin(id: user.uid, userData: userData)
              }
            }
          })
        }
        
      })
    }
  }
  
  func completeSignin(id: String, userData: Dictionary<String, String>) {
    DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
    let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
    print("STEVEN: Data saved to keychain \(keychainResult)")
    performSegue(withIdentifier: "goToFeed", sender: nil)
  }

}
