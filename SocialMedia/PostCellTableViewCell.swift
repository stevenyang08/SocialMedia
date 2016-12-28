//
//  PostCellTableViewCell.swift
//  SocialMedia
//
//  Created by Steven Yang on 11/22/16.
//  Copyright © 2016 Steven Yang. All rights reserved.
//

import UIKit

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
  
  func configureCell(post: Post) {
    self.post = post
    self.caption.text = post.caption
    if let like = post.likes {
      self.likesLabel.text = "\(like)"
    }
    
//    if let url = NSURL(string: post.imageURL) as? URL {
//      if let data = NSData(contentsOf: url) as? Data {
//        self.postImage.image = UIImage(data: data)
//      }
//    }

  }

}
