//
//  thumbView.swift
//  Template
//
//  Created by Mac on 17.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class thumbView: UIView {
    private static var referance : thumbView? = thumbView()
    static var ref: thumbView {
        if referance == nil { referance  = thumbView() }
        return referance!
    }
    var currentView = UIView()
    var parentView = UIView()
    private var closeButton : UIButton = UIButton()
    private var imageView : UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    private func setup(){
        self.parentView = {
            let view = DefaultItems.referance.defView(withColor: .white)
            CustomizeItems.referance.roundedView25(with: view)
            view.frame = CGRect(x: 20, y: -1*screenHeigth, width: screenWith - 40, height: 400)
            CustomizeItems.referance.roundedView25(with: view)
            return view
        }()
        self.closeButton = {
            let btn = DefaultItems.referance.defButton(withText: "X", andButtonColor: .white)
            btn.setTitleColor(.blue, for: .normal)
            btn.frame = CGRect(x: self.parentView.frame.size.width - 60, y: 20, width: 50, height: 50)
            CustomizeItems.referance.roundedButton50(with: btn)
            btn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
            return btn
        }()
        self.imageView = {
             let imageView = UIImageView()
            imageView.frame = self.parentView.bounds
            return imageView
        }()
        self.parentView.addSubview(self.imageView)
        self.parentView.addSubview(self.closeButton)
        self.parentView.bringSubviewToFront(self.closeButton)
    }
    func showAlert(with view : UIView , imageURL : String)
      {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           window?.addSubview(self.parentView)
           currentView = view
           currentView.layer.opacity = 0.4
           self.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
           UIView.animate(withDuration: 1.0) {
                    self.parentView.frame = CGRect(x: 20, y:(screenHeigth*0.5) - 200, width:screenWith - 40, height: 400)
          }
     }
    @objc func closeTapped() {
           parentView.removeFromSuperview()
           currentView.layer.opacity = 1.0
           UIView.animate(withDuration: 1.0) {
               self.parentView.frame = CGRect(x: 20, y:-1*screenHeigth, width:screenWith - 40, height: 400)
           }
            thumbView.referance = nil
       }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
