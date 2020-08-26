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
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50, alignment: .center)
                Text("\(value, specifier: "%.0f")%")
                    .foregroundColor(.red)
            }
            .padding(.bottom,-20)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 30, height: 400)
                    .foregroundColor(.black)
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .red, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 30, height: value * 4)
                    .foregroundColor(.green)
            }
            //.padding(.bottom, 8)
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 40)
    }
}
