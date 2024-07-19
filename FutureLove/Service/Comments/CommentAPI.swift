

import Foundation

class CommentAPI: BaseAPI<CommentsServiceConfiguration> {
    static let shared = CommentAPI()
    
    func getLovehistory(page: Int,
                        completionHandler: @escaping (Result<CommentsModel, ServiceError>) -> Void) {
        fetchData(configuration: .getLovehistory(page: page),
                  responseType: CommentsModel.self) { result in
            completionHandler(result)
        }
    }
    func getSearchComment(word: String,
                          completionHandler: @escaping (Result<HomeModel, ServiceError>) -> Void) {
        fetchData(configuration: .getSearchComment(word: word),
                  responseType: HomeModel.self) { result in
            completionHandler(result)
        }
    }
}

