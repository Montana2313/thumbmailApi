//
//  apiPageVC.swift
//  Template
//
//  Created by Mac on 17.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class apiPageVC: UIViewController {
    let url = "https://gorest.co.in/public-api/photos?access-token=aIytpu5smL_3Klyhaxzv2JUT18nHOfaCwEIK"
    //MARK:-> Thumbnail'ları gelmesi ve doldurulması
    private var thumbArray : [ThumbmailData] = [ThumbmailData]() {
        didSet{
            self.thumbTableView.reloadData()
            self.loader.stopAnimating()
            self.loader.removeFromSuperview()
            animate(device: getDeviceModel())
        }
    }
    private var loader = getCustomLoader()
    private var thumbTableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setup()
        setupFrames(device: getDeviceModel())
        if Reachability.isConnectedToNetwork() == true {
            DataManager.init(string: url, type: .GET).requestGET()
            NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name(NotificationType.Thumbnail.rawValue), object:nil)
        }else {
            let alert = CustomAlerts.init().createDefaultAlert(withTitle: "Bilgi", andDesc: "İnternet Bağlantısı Yok", andButtonTitle: "Tamam")
            self.present(alert,animated: true,completion: nil)
        }
    }
    @objc func reload(notification:NSNotification){
        if let item = notification.userInfo?["data"] as? [ThumbmailData]{
            self.thumbArray = item
        }
    }
    // Notif sil
    deinit {
        NotificationCenter.default
         .removeObserver(self, name:  NSNotification.Name("thumbs"), object: nil)
    }
}
//MARK:-> Dizayn Protocol
extension apiPageVC : SetupViews {
    func setup() {
        self.thumbTableView = {
            let tbView = DefaultItems.referance.defTableView(with: thumbsCell.self)
            tbView.delegate = self
            tbView.dataSource = self
            tbView.separatorStyle = .singleLine
            return tbView
        }()
        self.loader.startAnimating()
        self.view.addSubview(self.loader)
        self.view.addSubview(self.thumbTableView)
    }
    func setupFrames(device: PhoneType) {
        self.thumbTableView.frame = CGRect(x: 0, y: screenHeigth + 10, width: screenWith, height: screenHeigth)
    }
    func animate(device: PhoneType) {
        UIView.animate(withDuration: 1.0) {
            self.thumbTableView.frame = CGRect(x: 0, y: 0, width: screenWith, height: screenHeigth)
        }
    }

}
//MARK:-> TableView Ayarları
extension apiPageVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.thumbArray.count > 0 {
            return self.thumbArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.thumbArray.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? thumbsCell else {fatalError("error")}
            cell.setThums(self.thumbArray[indexPath.row])
            return cell
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = "Veriler Bulunamadı"
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        thumbView.ref.showAlert(with: self.view,imageURL: self.thumbArray[indexPath.row].getImageURL())        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
