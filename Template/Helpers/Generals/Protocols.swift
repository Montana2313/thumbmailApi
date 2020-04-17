//
//  Protocols.swift
//  Template
//
//  Created by Mac on 17.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

protocol SetupViews {
    func setup()
    func setupFrames(device : PhoneType)
    func animate(device:PhoneType)
}
