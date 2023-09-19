//
//  BeerAPIManager.swift
//  GiveMeBeers
//
//  Created by 서동운 on 9/20/23.
//

import Foundation
import Alamofire

enum BeerError: Error {
    
}

class BeerApiManager {
    static let shared = BeerApiManager()
    private init() { }
    
    func request<T: Codable>(type: T.Type, api: BeerAPI, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(api, parameters: api.parameters, encoding: api.encoding).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
