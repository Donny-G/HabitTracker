//
//  AnimatedInfoImage.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 01.10.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation
import  SwiftUI

struct AnimatedImage: View {
    @State private var image: Image?
    let imageNames: [String]
    let width: CGFloat
    let height: CGFloat
    let duration: Double
    
    func animate() {
        var imageIndex: Int = 0
        Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { timer in
            if imageIndex < self.imageNames.count {
                self.image = Image(self.imageNames[imageIndex])
                imageIndex += 1
            
            } else {
                timer.invalidate()
            }
        }
    }

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
            Button(action: {
                self.animate()
            }) {
                Image("playButton")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .shadow(color: .black, radius: 1, x: 3, y: 3)
                
            }
        }
        .onAppear(perform: {
            self.animate()
        })
    }
}

