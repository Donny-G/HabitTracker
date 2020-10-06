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
    var height: CGFloat
    var secondHeight: CGFloat {
        return value * (height * 0.01)
    }
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
                Image("tree")
                    .resizable()
                    .frame(width: 100, height: height)
                    .shadow(color: .black, radius: 1, x: 3, y: 3)
                //    .foregroundColor(colorScheme == .light ? firstTextColorLight : .black)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: Gradient(colors: [blue, yellow, orange, red ]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 30, height: secondHeight)
            }
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 40, height: 300)
    }
}
