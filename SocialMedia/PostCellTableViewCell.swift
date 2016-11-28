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

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

}
