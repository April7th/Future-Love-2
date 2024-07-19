//
//  VideoModel.swift
//  FutureLove
//
//  Created by khongtinduoc on 11/3/23.
//

import UIKit
import AVFoundation

struct TempleVideoModel: Codable {
    var id : Int?
    var linkgoc : String?
    var noidung : String?
    var linkThump : String?
    mutating func initLoad(_ json:[String:Any]) ->TempleVideoModel{
        if let temp = json["id"] as? Int {id = temp}
        if let temp = json["linkgoc"] as? String {linkgoc = temp}
        if let temp = json["noidung"] as? String {
            noidung = temp
        }
        if let temp = json["Field4"] as? String {linkThump = temp}
        return self
    }
    
}


struct Temple2VideoModel: Codable {
    var id : Int?
    var id_categories:Int?
    var age_video:Int?
    var chung_toc:String?
    var gioi_tinh : String?
    var link_video : String?
    var mau_da : String?
    var noi_dung : String?
    var thumbnail : String?
    mutating func initLoad(_ json:[String:Any]) ->Temple2VideoModel{
        if let temp = json["id"] as? Int {id = temp}
        if let temp = json["id_categories"] as? Int {id_categories = temp}
        if let temp = json["age_video"] as? Int {age_video = temp}
        if let temp = json["chung_toc"] as? String {
            chung_toc = temp
        }
        if let temp = json["gioi_tinh"] as? String {gioi_tinh = temp}
        if let temp = json["link_video"] as? String {link_video = temp}
        if let temp = json["mau_da"] as? String {mau_da = temp}
        if let temp = json["noi_dung"] as? String {noi_dung = temp}
        if let temp = json["noi_dung"] as? String {noi_dung = temp}
        if let temp = json["thumbnail"] as? String {thumbnail = temp}
        return self
    }
    
}

struct ResultVideoModel: Codable {
    var id_video : String?
    var link_image : String?
    var link_vid_swap : String?
    var ten_su_kien : String?
    var noidung_sukien : String?
    var id_video_swap : String?
    var thoigian_taovid : String?
    var id_user : Int?
    var count_comment : Int?
    var count_view : Int?
    var thoigian_taosk:String?
    var thoigian_swap:String?
    
    mutating func initLoad(_ json:[String:Any]) ->ResultVideoModel{
        if let temp = json["id_video"] as? String {id_video = temp}
        if let temp = json["link_image"] as? String {link_image = temp}
        if let temp = json["link_vid_swap"] as? String {
            link_vid_swap = temp
        }
        if let temp = json["thoigian_swap"] as? String {thoigian_swap = temp}
        if let temp = json["thoigian_taosk"] as? String {thoigian_taosk = temp}
        if let temp = json["ten_su_kien"] as? String {ten_su_kien = temp}
        if let temp = json["noidung_sukien"] as? String {noidung_sukien = temp}
        if let temp = json["id_video_swap"] as? String {id_video_swap = temp}
        if let temp = json["thoigian_taovid"] as? String {thoigian_taovid = temp}
        if let temp = json["id_user"] as? Int {id_user = temp}
        if let temp = json["count_comment"] as? Int {count_comment = temp}
        if let temp = json["count_view"] as? Int {count_view = temp}

        return self
    }
    
}

struct VideoModel: Codable {
    var id_video : String?
    var link_image : String?
    var link_vid_swap : String?
    var ten_su_kien : String?
    var noidung_sukien : String?
    var id_video_swap : String?
    var thoigian_taovid : String?
    var id_user : Int?
    var count_comment : Int?
    var count_view : Int?
    
    mutating func initLoad(_ json:[String:Any]) ->VideoModel{
        if let temp = json["id_video"] as? String {id_video = temp}
        if let temp = json["link_image"] as? String {link_image = temp}
        if let temp = json["link_vid_swap"] as? String {
            link_vid_swap = temp
        }
        if let temp = json["ten_su_kien"] as? String {ten_su_kien = temp}
        if let temp = json["noidung_sukien"] as? String {noidung_sukien = temp}
        if let temp = json["id_video_swap"] as? String {
            id_video_swap = temp
        }
        if let temp = json["thoigian_taovid"] as? String {thoigian_taovid = temp}
        if let temp = json["id_user"] as? Int {id_user = temp}
        if let temp = json["count_comment"] as? Int {
            count_comment = temp
        }
        if let temp = json["count_view"] as? Int {count_view = temp}
        return self
    }
    
}
struct SukienSwapVideo: Codable {
    var idSaved: String?
    var linkVideoGoc: String?
    var linkImage: String?
    var linkVidSwap: String?
    var thoigianSukien: String?
    var deviceTaoVid: String?
    var ipTaoVid: String?
    var idUser: Int?

    mutating func initLoad(_ json:[String:Any]) -> SukienSwapVideo {
        if let data = json["sukien_video"] as? [String: Any] {
            if let temp = data["id_saved"] as? String { idSaved = temp }
            if let temp = data["link_vid_goc"] as? String { linkVideoGoc = temp }
            if let temp = data["linkimg"] as? String { linkImage = temp }
            if let temp = data["link_vid_swap"] as? String { linkVidSwap = temp }
            if let temp = data["thoigian_sukien"] as? String { thoigianSukien = temp }
            if let temp = data["device_tao_vid"] as? String { deviceTaoVid = temp }
            if let temp = data["ip_tao_vid"] as? String { ipTaoVid = temp }
            if let temp = data["id_user"] as? Int { idUser = temp }
        }

        return self
    }
}
struct SukienSwapVideoUpdate: Codable {
    var id_saved: String?
    var link_video_goc: String?
    var link_image: String?
    var link_vid_da_swap: String?
    var thoigian_sukien: String?
    var device_tao_vid: String?
    var ip_tao_vid: String?
    var id_user: Int?

    mutating func initLoad(_ json:[String:Any]) -> SukienSwapVideoUpdate {
        if let data = json["sukien_swap_video"] as? [String: Any] {
            if let temp = data["id_saved"] as? String { id_saved = temp }
            if let temp = data["link_video_goc"] as? String { link_video_goc = temp }
            if let temp = data["link_image"] as? String { link_image = temp }
            if let temp = data["link_vid_da_swap"] as? String { link_vid_da_swap = temp }
            if let temp = data["thoigian_sukien"] as? String { thoigian_sukien = temp }
            if let temp = data["device_tao_vid"] as? String { device_tao_vid = temp }
            if let temp = data["ip_tao_vid"] as? String { ip_tao_vid = temp }
            if let temp = data["id_user"] as? Int { id_user = temp }
        }

        return self
    }
}

//"id_saved": "352190473574",
//"link_src_goc": "/var/www/build_futurelove/image/image_user/236/video/236_vid_47083.jpg",
//"link_tar_goc": "/var/www/build_futurelove/image/image_user/236/video/236_vid_35532.jpg",
//"link_da_swap": "https://futurelove.online/image/gen_image/590290_925494033564/out/236_vid_35532.jpg",
//"id_toan_bo_su_kien": "352190473574",
//"thoigian_sukien": "2024-01-30, 15:49:00",
//"device_them_su_kien": "gdgdg",
//"ip_them_su_kien": "dfbdfbd",
//"id_user": 3,
//"count_comment": 0,
//"count_view": 0,
//"id_template": 4,
//"loai_sukien": "swap_2face",
//"id_all_sk": "null"
struct SukienSwap2Image: Codable {
    var id_saved: String?
    var link_src_goc: String?
    var link_tar_goc: String?
    var link_da_swap: String?
    var thoigian_sukien: String?
    var device_them_su_kien: String?
    var ip_them_su_kien: String?
    var id_user: Int?

    mutating func initLoad(_ json:[String:Any]) -> SukienSwap2Image {
        if let data = json["sukien_2_image"] as? [String: Any] {
            if let temp = data["id_saved"] as? String { id_saved = temp }
            if let temp = data["link_src_goc"] as? String { link_src_goc = temp }
            if let temp = data["link_tar_goc"] as? String { link_tar_goc = temp }
            if let temp = data["link_da_swap"] as? String { link_da_swap = temp }
            if let temp = data["thoigian_sukien"] as? String { thoigian_sukien = temp }
            if let temp = data["device_them_su_kien"] as? String { device_them_su_kien = temp }
            if let temp = data["ip_them_su_kien"] as? String { ip_them_su_kien = temp }
            if let temp = data["id_user"] as? Int { id_user = temp }
        }

        return self
    }
}
