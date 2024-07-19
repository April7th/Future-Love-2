//
//  ProfileAPI.swift
//  FutureLove
//
//  Created by TTH on 30/07/2023.
//

import Foundation

class ProfileAPI: BaseAPI<ProfileServiceConfiguration> {
    static let shared = ProfileAPI()
    
    func getRecentComment(id_user: Int,
                          completionHandler: @escaping (Result<RecentCommentModel, ServiceError>) -> Void) {
        fetchData(configuration: .getRecentComment(id_user:id_user),
                  responseType: RecentCommentModel.self) { result in
            completionHandler(result)
        }
    }
    func getProfile(id_user: Int,
                    completionHandler: @escaping (Result<ProfileModel, ServiceError>) -> Void) {
        fetchData(configuration: .getProfile(id_user: id_user),
                  responseType: ProfileModel.self) { result in
            completionHandler(result)
        }
    }
    func getUserEvent(id_user: Int,
                      completionHandler: @escaping (Result<HomeModel, ServiceError>) -> Void) {
        fetchData(configuration: .getUserEvent(id_user: id_user),
                  responseType: HomeModel.self) { result in
            completionHandler(result)
        }
    }
}

