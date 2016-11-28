//
//  CircleImageView.swift
//  SocialMedia
//
//  Created by Steven Yang on 11/22/16.
//  Copyright © 2016 Steven Yang. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = self.frame.width / 2
    clipsToBounds = true
  }
  
}
