//
//  PostCellTableViewCell.swift
//  SocialMedia
//
//  Created by Steven Yang on 11/22/16.
//  Copyright © 2016 Steven Yang. All rights reserved.
//

import UIKit
import Firebase

class PostCellTableViewCell: UITableViewCell {

  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var caption: UITextView!
  @IBOutlet weak var likesLabel: UILabel!
  
  var post: Post!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configureCell(post: Post, image: UIImage? = nil) {
    self.post = post
    self.caption.text = post.caption
    if let like = post.likes {
      self.likesLabel.text = "\(like)"
    }
    
    if image != nil {
      self.postImage.image = image
    } else {
        let ref = FIRStorage.storage().reference(forURL: post.imageURL)
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
          if error != nil {
            print("STEVEN: Unable to download image from Firebase Storage")
          } else {
            print("STEVEN: Image downloaded from Firebase Storage")
            if let imgData = data {
              if let img = UIImage(data: imgData) {
                self.postImage.image = img
                FeedViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
              }
            }
          }
        })
    }
    
  }

}
