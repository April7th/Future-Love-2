//
//  DetailServiceConfiguration.swift
//  FutureLove
//
//  Created by TTH on 26/07/2023.
//

import Foundation

enum DetailServiceConfiguration {
    case getCommentEvent(id: Int, id_toan_bo_su_kien: String)
    case getDetailEvent(idsukien: Int)
    case postComments(noi_dung_cmt: String,
                      id_toan_bo_su_kien: String,
                      device_cmt: String ,
                      ipComment: String,
                      imageattach: String,
                      id_user: String,
                      so_thu_tu_su_kien: String,
                      location: String)
}

extension DetailServiceConfiguration: Configuration {
    
    var baseURL: String {
        switch self {
        case .getCommentEvent:
            return Constant.Server.baseAPIURL
        case .getDetailEvent:
            return Constant.Server.baseAPIURL
        case .postComments:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .getCommentEvent(let id, _):
            return "lovehistory/comment/\(id)"
        case .getDetailEvent(let idsukien):
            return "lovehistory/\(idsukien)"
        case .postComments:
            return "lovehistory/comment"
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCommentEvent:
            return .get
        case .getDetailEvent:
            return .get
        case .postComments:
            return .post
            
        }
    }
    
    var task: Task {
        switch self {
        case .getCommentEvent(_, let id_toan_bo_su_kien):
            let parameters = ["id_toan_bo_su_kien": id_toan_bo_su_kien]
            return .requestParameters(parameters: parameters)
        case .getDetailEvent:
            return .requestPlain
        case .postComments(let noi_dung_cmt, let id_toan_bo_su_kien,
                           let device_cmt , let ipComment,
                           let imageattach, let id_user, let so_thu_tu_su_kien, let location):
            let parameters = [
                "noi_dung_cmt": noi_dung_cmt,
                "id_toan_bo_su_kien": id_toan_bo_su_kien,
                "device_cmt": device_cmt,
                "ipComment": ipComment,
                "imageattach": imageattach,
                "id_user": id_user,
                "so_thu_tu_su_kien" : so_thu_tu_su_kien,
                "location": location]
            return .requestParameters(parameters: parameters)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var data: Data? {
        switch self {
        default:
            return nil
        }
    }
}
