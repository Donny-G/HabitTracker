//
//  BarView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct BarView: View {
    var value: CGFloat
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            ZStack {
                Circle()
                .frame(width: 78, height: 78, alignment: .center)
                    .foregroundColor(colorScheme == .light ? firstTextColorLight : .black)
                Circle()
                    .frame(width: 70, height: 70, alignment: .center)
                    .foregroundColor(blue)
                Text("\(value, specifier: "%.0f")%")
                    .foregroundColor(red)
            }
                .padding(.bottom,-12)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 40, height: 400)
                    .foregroundColor(colorScheme == .light ? firstTextColorLight : .black)
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: Gradient(colors: [blue, yellow, orange, red ]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 30, height: value * 4)
            }
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 40)
    }
}
