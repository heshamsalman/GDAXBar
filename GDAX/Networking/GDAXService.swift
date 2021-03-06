//
//  GDAXService.swift
//  GDAXBar
//
//  Created by Hesham Salman on 9/26/17.
//  Copyright © 2017 Hesham Salman. All rights reserved.
//

import Foundation
import Moya

enum GDAXService {
    case currencies
    case products
    case ticker(Product)
}

extension GDAXService: TargetType {
    var baseURL: URL { return URL(string: "https://api.gdax.com")! }
    var path: String {
        switch self {
        case .currencies:
            return "/currencies"
        case .products:
            return "/products"
        case let .ticker(product):
            return "/products/\(product.id)/ticker"
        }
    }
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .currencies:
            return stubbedResponse("Currencies")
        case .products:
            return stubbedResponse("Products")
        case .ticker(_):
            return stubbedResponse("Ticker")
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

func stubbedResponse(_ filename: String) -> Data! {
    let bundle = Bundle(identifier: "com.heshamsalman.GDAXTests")
    let path = bundle?.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
