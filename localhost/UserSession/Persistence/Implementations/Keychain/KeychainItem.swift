////
////  KeychainItem.swift
////  Contact
////
////  Created by Andrew O'Brien on 8/20/19.
////  Copyright © 2019 Andrew O'Brien. All rights reserved.
////
//
//import Foundation
//
//class KeychainItem {
//    
//    // MARK: - Properties
//    let service: NSString = "KooberCloud"
//    let itemClass = kSecClass as String
//    let itemService = kSecAttrService as String
//    
//    // MARK: - Methods
//    func asDictionary() -> CFDictionary {
//        let item: [String: AnyObject] = [itemClass: kSecClassGenericPassword,
//                                         itemService: service]
//        return item as CFDictionary
//    }
//}
//
//class KeychainItemWithData: KeychainItem {
//    
//    // MARK: - Properties
//    let data: AnyObject
//    let itemData = kSecValueData as String
//    
//    // MARK: - Methods
//    init(data: Data) {
//        self.data = data as AnyObject
//    }
//    
//    override func asDictionary() -> CFDictionary {
//        let item: [String: AnyObject] = [itemClass: kSecClassGenericPassword,
//                                         itemService: service,
//                                         itemData: data]
//        return item as CFDictionary
//    }
//    
//    func attributesAsDictionary() -> CFDictionary {
//        let attributes: [String: AnyObject] = [itemClass: kSecClassGenericPassword,
//                                               itemService: service]
//        return attributes as CFDictionary
//    }
//    
//    func dataAsDictionary() -> CFDictionary {
//        let justData: [String: AnyObject] = [itemData: data]
//        return justData as CFDictionary
//    }
//}
//
//class KeychainItemQuery: KeychainItem {
//    
//    // MARK: - Properties
//    let matchLimit = kSecMatchLimit as String
//    let returnData = kSecReturnData as String
//    
//    // MARK: - Methods
//    override func asDictionary() -> CFDictionary {
//        let query: [String: AnyObject] = [itemClass: kSecClassGenericPassword,
//                                          itemService: service,
//                                          matchLimit: kSecMatchLimitOne,
//                                          returnData: kCFBooleanTrue]
//        return query as CFDictionary
//    }
//}
//
