//
//  CPKEmptyView.swift
//  ClassifiedsApp
//
//  Created by Florian Marcu on 9/25/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import SwiftUI

protocol CPKEmptyViewHandler: class {
    func didTapActionButton()
}

struct CPKEmptyView: View {
    @State var model: CPKEmptyViewModel

    weak var handler: CPKEmptyViewHandler?

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if model.title != nil {
                Text(model.title!)
                    .bold()
                    .font(.largeTitle)
            }
            if model.description != nil {
                Text(model.description!)
                    .font(.body)
                    .offset(CGSize(width: 0, height: 30))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 20)
            }
            if model.callToAction != nil {
                Spacer(minLength: 50)
                Button(action: {
                    self.handler?.didTapActionButton()
                }) {
                    Text(model.callToAction!)
                        .foregroundColor(.white)
                        .bold()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.blue.opacity(0.9))
                .cornerRadius(7)
            }
        }
    }
}

struct CPKEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        let model = CPKEmptyViewModel(image: nil,
                                      title: "Test",
                                      description: "Description of SwiftUI empty view",
                                      callToAction: nil)
        return CPKEmptyView(model: model)
    }
}
