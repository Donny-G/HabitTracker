//
//  AlertView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 29.09.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct AlertView: View {
    @Binding var isContinue: Bool
    @Environment(\.colorScheme) var colorScheme
    var typeOfTimer: Int
    var alertWidth: CGFloat
    var alertHeight: CGFloat
    var tag: Int = 0
    
    
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(self.colorScheme == .light ? yellow : mint)
                    .shadow(color: .black, radius: 2, x: 5, y: 5)
                    .modifier(ButtonBorderModifier())
                VStack {
                    Text("Warning !")
                        .modifier(TextHeadLineModifier())
                    if self.tag == 0 {
                    Text("Please enter \( self.typeOfTimer == 0 ? "minutes" : "hours")")
                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                    } else {
                        Text("Please enter title of your notification")
                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                    }
                    Button(action: {
                        self.isContinue.toggle()
                    }) {
                        HStack {
                        Text("Continue")
                            .modifier(NotificationAndSaveButtonTextModifier(size: 20))
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                        Image("okButton")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(CurrentImageModifier(width: geo.size.width * 0.3, height: geo.size.width * 0.3))
                        }
                    }
                }
                    .buttonStyle(PlainButtonStyle())
            }
        }.frame(width: alertWidth, height: alertHeight, alignment: .center)
        
    }
}

struct AlertView_Previews: PreviewProvider {
    struct TesAlert: View {
        @State var testItem: Bool = true
        var body: some View {
            AlertView(isContinue: $testItem, typeOfTimer: 0, alertWidth: 200, alertHeight: 200, tag: 0)
        }
    }
    static var previews: some View {
        TesAlert()
    }
}


