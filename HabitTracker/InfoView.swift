//
//  InfoView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ImageInfoModifier: ViewModifier {
    var geo: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: geo, height: 80)
            .scaledToFit()
            .shadow(color: .black, radius: 1, x: 3, y: 3)
            .padding(.leading, 10)
    }
}

struct TextHeadLineModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30, weight: .black, design: .rounded))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .foregroundColor(colorScheme == .light ? firstTextColorLight : firstTextColorDark)
            .shadow(color: .black, radius: 1, x: 2, y: 2)
    }
}

struct TextDefModifier: ViewModifier {
    var geo: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .black, design: .rounded))
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(colorScheme == .light ? thirdTextColorLight : thirdTextColorDark)
            .shadow(color: .black, radius: 1, x: 1, y: 1)
            .frame(width: geo, alignment: .leading)
            .padding(.leading, 10)
    }
}

struct InfoView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.presentationMode) var presentationMode
   
    var imageNames: [String] {
        var images: [String] = []
        for i in 1...59 {
            images.append("Animation\(i)")
            print(images)
        }
        return images
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                self.colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
                GeometryReader { geo in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("Do good things to grow good habits")
                                .font(.system(size: 25, weight: .black, design: .rounded))
                                .foregroundColor(self.colorScheme == .light ? firstTextColorLight : firstTextColorDark)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                .frame(width: geo.size.width * 0.8,height: geo.size.height * 0.2, alignment: .center)
                                .padding(.leading, 10)
                            
                            AnimatedImage(imageNames: self.imageNames, width: geo.size.width, height: geo.size.height / 2, duration: 0.08)
                                
                            Text("Main View & Habit View")
                                .modifier(TextHeadLineModifier())
                    
                            Group {
                                HStack {
                                    Image("add2")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                               
                                    Text("Press the button to add new habit")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("activeForInfo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("ActiveHabits")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("completedForInfo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("CompletedHabits")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("statsForInfo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("ProgressView")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("tap")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("By long pressing on habit you can add one step to your goal")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("tapButton")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Press the button to add new step to your goal")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("delete")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Delete current habit")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                            }
            
                            Spacer()
            
                            Text("New habit view")
                                .modifier(TextHeadLineModifier())
            
                            Group {
                                HStack {
                                    Image("setNotificationOn")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Set new local notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("setNotificationOff")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Disable and delete current local notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("typesForInfo")
                                        .resizable()
                                        .frame(width: geo.size.width * 0.2, height: 20)
                                        .scaledToFit()
                                        .shadow(color: .black, radius: 1, x: 3, y: 3)
                                        .padding(.leading, 10)
                            
                                    Text("Choose type of predifined habit")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                   
                                }
                                HStack {
                                    Image("gallery")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("You can choose picture for habit from gallery")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("photo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Or you can take picture for habit from camera")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                            }
            
                            Spacer()
            
                            Text("Notification")
                                .modifier(TextHeadLineModifier())
                
                            Group {
                                HStack() {
                                    Image("notificationIsOn")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Notification is enabled")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("notificationIsOff")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Notification is disabled")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("auto")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Default notification at 9:00 everyday")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("manual")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Manual notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("timer2")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Countdown timer")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("alarm")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Time notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("continues")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Repeated notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("notContinues")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Not repeating notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("daysweek")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Sheduled dayly notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                            }
                        }
                    }
                
                }
                
                }   .navigationBarTitle("i", displayMode: .inline)
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationBarItems(leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(self.colorScheme == .light ? tabBarTextPrimaryLightColor  : tabBarTextPrimaryDarkColor)
                    })
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
