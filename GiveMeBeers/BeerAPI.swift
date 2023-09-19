//
//  BeerAPIAPI.swift
//  GiveMeBeers
//
//  Created by 서동운 on 9/20/23.
//

import Foundation
import Alamofire

enum BeerAPI: URLConvertible {
    case getSingleBeer
    case getRandomBeer
    case getBeers(Int)
}

extension BeerAPI {
    var baseURL: String {
        "https://api.punkapi.com/v2"
    }
    
    var path: String {
        switch self {
        case .getSingleBeer: return "/beers/1"
        case .getRandomBeer: return "/beers/random"
        case .getBeers: return "/beers"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .getBeers(let page): return ["page": page]
        default: return nil
        }
    }
    
    var encoding: URLEncoding {
        switch self {
        case .getBeers: return .queryString
        default: return .default
        }
    }
    
    func asURL() throws -> URL {
        return URL(string: baseURL + path)!
    }
}
