//
//  NetworkManager.swift
//  CelebEthnicity
//
//  Created by User on 12.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Moya

enum NetworkService {
    case celebs
}

extension NetworkService: TargetType {
    
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .celebs:
            return "/celebs"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Moya.Data {
        switch self {
        case .celebs:
            return "{\"userId\": \(1), \"id\": \(1), \"title\": \"sunt aut facere\", \"body\": \"quia et suscipit\nsuscipit\"}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
