//
//  DeepLinkOptions.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

// set URL Scheme in entitlements
enum DeepLinkOption {
    case profileDetail(String)
    case chat(String)
    
    static func build(with dict: [AnyHashable: Any]) -> DeepLinkOption? {
        var deepLinkOption: DeepLinkOption? = nil
        
        guard let target = dict["target"] as? String, let senderId = dict["senderId"]  as? String else {
            print("NO TARGET")
            return nil
        }
        
        if (target == "nod") {
            deepLinkOption = .profileDetail(senderId)
        }
        
        if (target == "chat") {
            deepLinkOption = .chat(senderId)
        }
        
        return deepLinkOption
    }
}
