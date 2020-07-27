//
//  ProgressCircle.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 27.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ProgressCircle: View {
    var percent: CGFloat = 0
    var colors: [Color] = [.red, .orange, .yellow, .green, .purple, .blue]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .trim(from: 0, to: percent * 0.01)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .fill(AngularGradient(gradient: .init(colors: colors), center: .center, startAngle: .zero, endAngle: .init(degrees: 360)))
            ).animation(.spring(response: 1.0, dampingFraction: 1.0, blendDuration: 1.0))
            Text(String(format: "%.1f", percent) + "%").font(.system(size: 20)).fontWeight(.heavy)
                
        }
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle()
    }
}
