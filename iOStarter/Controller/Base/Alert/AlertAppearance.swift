//
//  AlertAppearance.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 10/12/20.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

class AlertAppearance {
    var titleColor      = UIColor.black
    var titleFont       = UIFont.boldSystemFont(ofSize: 17)
    var messageColor    = UIColor.black
    var messageFont     = UIFont.systemFont(ofSize: 13)
    var dismissText     = "Cancel"
    var dismissColor    = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
    var okeText         = "Submit"
    var okeColor        = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
    var buttonFont      = UIFont.systemFont(ofSize: 17)
    var backgroundColor = UIColor.white
    var overlayColor    = UIColor.black.withAlphaComponent(0.4)
    var isBlurContainer = false
}
