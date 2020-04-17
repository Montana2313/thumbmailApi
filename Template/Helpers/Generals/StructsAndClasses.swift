//
//  StructsAndClasses.swift
//  Template
//
//  Created by Mac on 7.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

struct ThumbmailData {
    private var title : String = ""
    private var imageURL : String = ""
    init(title : String , url:String) {
        self.title = title
        self.imageURL = url
    }
    func getTitle()->String{
        return self.title
    }
    func getImageURL()->String{
        return self.imageURL
    }
}
