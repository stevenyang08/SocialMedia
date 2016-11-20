//
//  FancyView.swift
//  SocialMedia
//
//  Created by Steven Yang on 11/20/16.
//  Copyright © 2016 Steven Yang. All rights reserved.
//

import UIKit

class FancyView: UIView {

  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 5.0
    layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    
  }

}
