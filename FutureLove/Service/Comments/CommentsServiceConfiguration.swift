

import Foundation

enum CommentsServiceConfiguration {
    case getLovehistory(page: Int)
    case getSearchComment(word: String)

}

extension CommentsServiceConfiguration: Configuration {
    
    var baseURL: String {
        switch self {
        case .getLovehistory:
            return Constant.Server.baseAPIURL
        case .getSearchComment:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .getLovehistory(let page):
            return "lovehistory/pageComment/\(page)"
        case .getSearchComment:
            return "search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLovehistory:
            return .get
        case .getSearchComment:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getLovehistory:
            return .requestPlain
        case .getSearchComment:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getSearchComment(let word):
            let headers:[String:String] = ["word": word]
            return headers
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
