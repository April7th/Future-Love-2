//
//  DetailAPI.swift
//  FutureLove
//
//  Created by TTH on 26/07/2023.
//

import Foundation

class DetailAPI: BaseAPI<DetailServiceConfiguration> {
    static let shared = DetailAPI()
    
    func getCommentEvent (id: Int,
                          id_toan_bo_su_kien: String,
                          completionHandler: @escaping (Result<CommentEvent, ServiceError>) -> Void) {
        fetchData(configuration: .getCommentEvent(id: id, id_toan_bo_su_kien: id_toan_bo_su_kien),
                  responseType: CommentEvent.self) { result in
            completionHandler(result)
        }
    }
    
    func getDetailEvent (idsukien: Int,
                         completionHandler: @escaping (Result<DetailEvent, ServiceError>) -> Void) {
        fetchData(configuration: .getDetailEvent(idsukien: idsukien),
                  responseType: DetailEvent.self) { result in
            completionHandler(result)
        }
    }
    
    func postComments (noi_dung_cmt: String,
                       id_toan_bo_su_kien: String,
                       device_cmt: String ,
                       ipComment: String,
                       imageattach: String,
                       id_user: String,
                       so_thu_tu_su_kien: String, location: String,
                       completionHandler: @escaping (Result<PostComments, ServiceError>) -> Void) {
        fetchData(configuration: .postComments(noi_dung_cmt: noi_dung_cmt,
                                               id_toan_bo_su_kien: id_toan_bo_su_kien,
                                               device_cmt: device_cmt,
                                               ipComment: ipComment,
                                               imageattach: imageattach,
                                               id_user: id_user,
                                               so_thu_tu_su_kien: so_thu_tu_su_kien,
                                               location:location), responseType: PostComments.self) { result in
            completionHandler(result)
        }
    }
    
    
}
