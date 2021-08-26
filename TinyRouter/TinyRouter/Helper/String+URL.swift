//
//  String+URL.swift
//  TinyRouter
//
//  Created by liulishuo on 2021/8/20.
//

import Foundation
import UIKit

extension String {

    var key: String? {
        get {
            guard let components = URLComponents(string: self) else {
                return nil
            }

            guard let scheme = components.scheme else {
                return nil
            }

            guard let host = components.host else {
                return nil
            }

            let path = components.path

            return "\(scheme)://\(host)\(path)"
        }
    }

    var query: [String: String]? {
        get {
            var query = [String: String]()
            URLComponents(string: self)?.queryItems?.forEach({ item in
                guard let value = item.value else {
                    return
                }
                query[item.name] = value
            })
            return query
        }
    }

    var url: URL? {
        get {
            // Check for existing percent escapes first to prevent double-escaping of % character
            if self.range(of: "%[0-9A-Fa-f]{2}", options: .regularExpression, range: nil, locale: nil) != nil {
                return Foundation.URL(string: self)
            } else if let encodedString_ = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                return Foundation.URL(string: encodedString_)
            } else {
                return nil
            }
        }
    }
}
