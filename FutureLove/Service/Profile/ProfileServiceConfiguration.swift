//
//  ProfileServiceConfiguration.swift
//  FutureLove
//
//  Created by TTH on 30/07/2023.
//


import Foundation
import Alamofire

enum ProfileServiceConfiguration {
    case getRecentComment(id_user: Int)
    case getProfile(id_user: Int)
    case getUserEvent(id_user: Int)
    
}

extension ProfileServiceConfiguration: Configuration {
    
    var baseURL: String {
        switch self {
        case .getRecentComment:
            return Constant.Server.baseAPIURL
        case .getProfile:
            return Constant.Server.baseAPIURL
        case .getUserEvent:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .getRecentComment(let id_user):
            return "lovehistory/comment/user/\(id_user)"
        case .getProfile(let id_user):
            return "profile/\(id_user)"
        case .getUserEvent(let id_user):
            return "lovehistory/user/\(id_user)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRecentComment:
            return .get
        case .getProfile:
            return .get
        case .getUserEvent:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getRecentComment:
            return .requestPlain
        case .getProfile:
            return .requestPlain
        case .getUserEvent:
            return .requestPlain
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

