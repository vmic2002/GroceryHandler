//
//  PictureReceipt.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/27/22.
//

import SwiftUI

//code for this view is taken/copied from https://designcode.io/swiftui-advanced-handbook-imagepicker
struct PictureReceipt: View {
    @State var username:String
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var cameraOrLibrary = false//true for camera false for library->BUG that user is shown library no matter what button he presses if cameraOrLibrary==false, user is shown camera if cameraOrLibrary==true
    @State private var addUsers = false
    @State private var prices = [Double]()
    
    var body: some View {
        VStack {
            Text("Hey, \(username)")
                .font(.title)
                .foregroundColor(Color.green)
                .multilineTextAlignment(.center)
            Text("Choose photo from library")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .onTapGesture {
                    cameraOrLibrary = false
                    showSheet = true
                }
            Image(uiImage: self.image)
                .resizable()
                .cornerRadius(50)
                .frame(width: 300, height: 400)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
            //.clipShape(Circle())
            
            Text("Take photo")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .onTapGesture {
                    cameraOrLibrary = true
                    showSheet = true
                }
            NavigationLink(destination: AddUsers(username:username, prices: prices), isActive: $addUsers){EmptyView()}
            Button("Verify Photo"){
                print("1111111Verify photo clicked")
                prices = getPrices(image:image)
                print("22222222after get prices method")
               // prices = [1.0, 2.2]
                //getPricesAsArray(image: image)//COMMENT
                
                addUsers = true
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showSheet) {
            // Pick an image from the photo library:
            
            if (cameraOrLibrary){
                ImagePicker(sourceType: .camera, selectedImage: self.$image)
            } else {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            
            
            //  If you wish to take a photo from camera instead:
            // ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
    }
}

struct PictureReceipt_Previews: PreviewProvider {
    static var previews: some View {
        PictureReceipt(username:"userName")
    }
}
