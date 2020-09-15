//
//  ProgressBar.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 27.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    var percent: CGFloat = 70
    var colors: [Color] = [red, orange, yellow, blue]
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .fill(colorScheme == .light ? firstTextColorLight : .black)
                .frame(width: 110, height: 25)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(gradient: .init(colors: colors), startPoint: .leading, endPoint: .trailing))
                .frame(width: percent, height: 20)
                .padding(.leading, 5)
                .animation(.spring(response: 1.0, dampingFraction: 1.0, blendDuration: 1.0))
        // Text(String(format: "%.0f", percent) + "%").font(.system(size: 20)).fontWeight(.heavy)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
