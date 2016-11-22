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

class SignInViewController: UIViewController {

  @IBOutlet weak var emailTextField: FancyTextField!
  @IBOutlet weak var passwordTextField: FancyTextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
      }
    })
  }
    
  @IBAction func signinButtonTapped(_ sender: Any) {
    
    if let email = emailTextField.text, let password = passwordTextField.text {
      
      FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
        
        if error == nil {
          print("STEVEN: Email user authenticate with Firebase")
        } else {
          
          print("User doesn't exist")
          FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
              
              print("STEVEN: Unable to authenticate with Firebase using email")
            } else {
              
              print("STEVEN: Successfully authenticated with Firebase")
            }
          })
        }
        
      })
    }

  }

}
