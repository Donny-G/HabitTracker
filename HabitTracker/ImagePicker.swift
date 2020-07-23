//
//  ImagePicker.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 22.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    //2 прописываем какой тип контроллера надо внедрить
   // typealias UIViewControllerType = UIImagePickerController
    
    //6 прописыааем биндинг и энвайромент переменные
    @Binding var image: UIImage?
    @Binding var typeOfSource: Int
    @Environment(\.presentationMode) var presentationMode
    
    //4 создаем класс координатор,наследуемый от NSObject со всеми необходимыми протоколами в котром инициализируем родительсткую структуруу для использования переменных напрямую. прописыааем методы из вью контроллера
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
           var parent: ImagePicker
           init(_ parent:ImagePicker) {
               self.parent = parent
           }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
       }
    
    //5 метод создания коррдинатора в котором указываем коррдинатор
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //3 создаем метод создания контроллера в котором создаем контроллер и делегат
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        switch typeOfSource {
        case 0:
            picker.sourceType = .camera
        case 1:
            picker.sourceType = .photoLibrary
        default:
            picker.sourceType = .savedPhotosAlbum
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
}
