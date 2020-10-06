//
//  ProgressCircle.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 27.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ProgressCircle: View {
    @Environment(\.colorScheme) var colorScheme
    var percent: CGFloat = 90
    var colors: [Color] = [red, orange, yellow, blue]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(colorScheme == .light ? blue : firstTextColorLight)
                .frame(width: 90, height: 90)
                .overlay(
                    Circle()
                        .trim(from: 0, to: percent * 0.01)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .fill(AngularGradient(gradient: .init(colors: colors), center: .center, startAngle: .zero, endAngle: .init(degrees: 360))))
                        .animation(.spring(response: 1.0, dampingFraction: 1.0, blendDuration: 1.0))
                        .shadow(color: .black, radius: 1, x: 5, y: 5)
            Image("leaf3")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
            Text(String(format: "%.0f", percent) + "%").font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundColor(.yellow)
                .shadow(color: .black, radius: 1, x: 2, y: 2)
        }
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle()
    }
}
