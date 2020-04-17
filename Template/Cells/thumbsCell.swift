//
//  thumbsCell.swift
//  Template
//
//  Created by Mac on 17.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class thumbsCell: UITableViewCell {
    private var thumb : ThumbmailData!{
        didSet{
            self.thumbmailImage.sd_setImage(with: URL(string: thumb.getImageURL())) { (image, err, _, _) in
                if err == nil {
                    if let indicator = self.thumbmailImage.subviews.first as? NVActivityIndicatorView {
                        indicator.removeFromSuperview()
                    }
                }else {print(err?.localizedDescription as Any)}
            }
            self.thumbTitle.text = thumb.getTitle()
        }
    }
    private var thumbmailImage : UIImageView = UIImageView()
    private var thumbTitle : UILabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
             super.init(style: style , reuseIdentifier: reuseIdentifier)
            setConfig(bgColor: .clear)
    }
    private func setConfig(bgColor : UIColor? = nil){
        if let color = bgColor {self.backgroundColor = color}
        setup()
    }
    private func setup(){
        self.thumbmailImage = {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 20, y: 20, width: 60, height: 60)
            CustomizeItems.referance.roundedImageView(with: imageView)
            //Loader , Server'dan resimler bazen çok geç geliyor bu yüzden ekledim.
            let loader = NVActivityIndicatorView(frame: CGRect(x:15, y: 15, width: 30, height: 30), type: .ballPulse, color: UIColor.blue, padding: 0)
            loader.startAnimating()
            imageView.addSubview(loader)
            return imageView
        }()
        self.thumbTitle = {
            let lbl = DefaultItems.referance.defLabel(withText: "", andLabelColor: .black)
            lbl.font = UIFont(name: "Helvetica", size: 15.0)
            lbl.numberOfLines = 0
            lbl.textAlignment = .left
            lbl.frame = CGRect(x: 90, y: 20, width: screenWith - 100, height: 70)
            return lbl
        }()
        self.addSubview(thumbTitle)
        self.addSubview(thumbmailImage)
    }
    func setThums(_ data : ThumbmailData){
        self.thumb = data
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
