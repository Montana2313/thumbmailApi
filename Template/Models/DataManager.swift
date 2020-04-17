//
//  DataManager.swift
//  Template
//
//  Created by Mac on 13.10.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
class DataManager {
    private var urlString : String = ""
    private var request:OwnRequestType! // GET
    init(string:String , type:OwnRequestType) {
        self.urlString = string
        self.request = type
    }

    func requestGET(){
        guard let url = URL(string: self.urlString) else{fatalError()}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = self.request.rawValue
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
                  if let response = response {
                                     let nsHTTPResponse = response as! HTTPURLResponse
                                     let statusCode = nsHTTPResponse.statusCode
                                     print ("status code = \(statusCode)")
                                 }
                   if let error = err {
                           print ("\(error)")
                   }
                   if let data = data {
                       do{
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any> {
                                DispatchQueue.main.async {
                                    // Dönen veri _NSArrayM tipinde
                                    if let results = jsonResponse["result"] as? NSMutableArray{
                                        var thumbArray : [ThumbmailData] = [ThumbmailData]()
                                        guard let titles = results.value(forKey: "title") as? [String] else {return}
                                        guard let thumbmail = results.value(forKey: "thumbnail") as? [String] else {return}
                                        for (title , thums ) in zip(titles, thumbmail){
                                            thumbArray.append(ThumbmailData.init(title: title, url: thums))
                                        }
                                        print(thumbArray.count)
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationType.Thumbnail.rawValue), object: nil,userInfo: ["data":thumbArray])
                                    }else {
                                        print ("wrong format")
                                    }
                                }
                            }else {
                                print ("wrong format")
                            }
                        }catch _ {
                                print ("error")
                        }
                    }
               }
               task.resume()
    }
}
