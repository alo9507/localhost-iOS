//
//  PaddingLabelSwiftUI.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/24/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct PaddingLabelSwiftUI: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .padding(15.0)
            .lineLimit(nil)
            .font(Font(Fonts.avenirNext_demibold(20)))
            .foregroundColor(Color(UIColor.lhYellow))
            .multilineTextAlignment(.center)
    }
    
    static func vc(_ text: String) -> UIViewController {
        let paddedLabelVC = UIHostingController(rootView: PaddingLabelSwiftUI(text))
        
        // the view layer is constrained differently from the SwiftUI view it contains
        // this allows us to encapsulate the styling all in one
        paddedLabelVC.view.layer.cornerRadius = 25
        paddedLabelVC.view.backgroundColor = UIColor.lhTurquoise
        
        return paddedLabelVC
    }
}
