//
//  ContentView.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/13/22.
//

import SwiftUI



struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @ObservedObject var errorManager:ErrorManager = shared
    var body: some View {
        VStack{
            Text("Welcome to GroceryHandler")
                .font(.title)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 70)
                .padding(.bottom, 30)
                .frame(height: 70)
            Spacer()
            //instead of spacer could put an image here
            Form {
                TextField("Username: ", text: $username)
                    .padding(.all, 20)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit(){
                        print("SIGNING IN with \(username) and \(password)")
                        shared.errorMessage = ""
                    }
                TextField("Password: ", text: $password)
                    .padding(.all, 20)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit(){
                        print("SIGNING IN with \(username) and \(password)")
                        shared.errorMessage = ""
                    }
            }
            .frame(height: 199.0)
            .padding(.bottom, 50)
            //.background(Color.white)
            //Spacer()
         
            //Text("HI")
            Text(shared.errorMessage)
                .padding(.all, 30)
    
            Button("Sign in"){
                //make sure username and passowrd are correct then
                //switch to view where user can take picture, see past orders etc
                print("SIGNING IN with \(username) and \(password)")
            }.padding(.all, 20)
            HStack{
                Button("Create Account"){
                    if (username.count==0 || password.count==0){
                        //errorMessage = "Username and password cannot be empty"
                        shared.errorMessage = "Username and password cannot be empty"
                        return
                    }
                    print("Creating account with \(username) and \(password)")
                    createAccount(userName: username, password: password)
                    print("Done created account")
                }.padding(.all, 20)
                Button("Delete Account"){
                    if (username.count==0 || password.count==0){
                      //  errorMessage = "Username and password cannot be empty"
                        shared.errorMessage = "Username and password cannot be empty"
                        return
                    }
                    deleteAccount(userName: username, password: password)
                }.padding(.all, 20)
                Button("populate"){
                    //populateUserInfoDB()
                    populateOrdersDB(numNewOrders: 70)
                }
                //Spacer()
            }
            Spacer()
        }//.background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
