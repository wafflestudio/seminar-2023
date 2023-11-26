//
//  Interceptor.swift
//  Seminar2Solution
//
//  Created by user on 2023/10/07.
//

import Foundation
import Alamofire

final class Interceptor: RequestInterceptor {
    let token: String
    init(token: String) {
        self.token = token
    }

    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}
