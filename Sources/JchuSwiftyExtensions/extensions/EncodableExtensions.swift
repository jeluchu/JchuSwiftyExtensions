//
//  EncodableExtensions.swift
//  
//
//  Authors: Jeluchu
//  Creation: 5/5/23
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    func asStringDictionary() throws -> [String: String] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else {
            throw NSError()
        }
        return dictionary
    }

    func getURLFormData() -> Data? {
        guard let dict = try? self.asDictionary() else { return nil }
        let jsonString = dict.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        return jsonString.data(using: .utf8, allowLossyConversion: false)
    }

    func getURLEncodedFormData() -> Data? {
        guard let dict = try? self.asDictionary() else { return nil }
        let dictionaryWithPercentEncoding: [String: Any] = dict.mapValues(addPercentEncoding)
        let jsonString = dictionaryWithPercentEncoding.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        return jsonString.data(using: .utf8, allowLossyConversion: false)
    }

    func getCompactURLStringFormData() -> Data? {
        guard var dict = try? self.asStringDictionary() else { return nil }
        dict = dict.filter { $0.value != ""}
        let jsonString = dict.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        return jsonString.data(using: .utf8, allowLossyConversion: false)
    }

    func getJsonData() -> Data? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return data
    }
}

private extension Encodable {
    func addPercentEncoding(_ value: Any) -> Any {
        if let string = value as? String {
            return string.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? value
        } else {
            return value
        }
    }
}

private extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        return allowed
    }()
}
