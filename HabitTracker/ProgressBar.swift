//
//  ProgressBar.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 27.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    var percent: CGFloat = 50
       var colors: [Color] = [.red, .orange, .yellow, .green, .purple, .blue]
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 100, height: 10)
                .overlay(
                    Rectangle()
                        .trim(from: 0, to: percent * 0.003)
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        
                        .fill(LinearGradient(gradient: .init(colors: colors), startPoint: .leading, endPoint: .trailing))
                ).animation(.spring(response: 1.0, dampingFraction: 1.0, blendDuration: 1.0))
            
            Text(String(format: "%.1f", percent) + "%").font(.system(size: 20)).fontWeight(.heavy)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
