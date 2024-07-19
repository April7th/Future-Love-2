//
//  LinkGameModel.swift
//  FutureLove
//
//  Created by khongtinduoc on 6/24/24.
//

import UIKit

struct LinkGameModel: Codable {
    var title: String?
    var link: String?
    var titleGloss : String?
    var sizeWeb:Int?
    var statusBarHeightServer:Int?
    mutating func initLoad(_ json:[String:Any]) ->LinkGameModel{
        if let temp = json["title"] as? String {title = temp}
        if let temp = json["link"] as? String {link = temp}
        if let temp = json["titleGloss"] as? String {titleGloss = temp}
        if let temp = json["size"] as? Int {sizeWeb = temp}
        if let temp = json["statusBarHeight"] as? Int {statusBarHeightServer = temp}

        return self
    }

}
