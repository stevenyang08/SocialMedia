//
//  FancyTextField.swift
//  SocialMedia
//
//  Created by Steven Yang on 11/20/16.
//  Copyright © 2016 Steven Yang. All rights reserved.
//

import UIKit

class FancyTextField: UITextField {

  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 2.0
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    
    return bounds.insetBy(dx: 10, dy: 5)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    
    return bounds.insetBy(dx: 10, dy: 5)
  }

}
