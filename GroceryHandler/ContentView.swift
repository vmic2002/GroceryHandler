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
    @State private var signin = false
    @State private var changePassword = false
    //https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui
    var body: some View {
        NavigationView {
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
                            //print("SIGNING IN with \(username) and \(password)")
                            shared.errorMessage = ""
                        }
                    TextField("Password: ", text: $password)
                        .padding(.all, 20)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit(){
                            //print("SIGNING IN with \(username) and \(password)")
                            shared.errorMessage = ""
                        }
                }
                .frame(height: 199.0)
                .padding(.bottom, 50)
                //.moveDisabled(true)
                //.disabled(true)//to prevent scrolling
                //.background(Color.white)
                //Spacer()
                
                //Text("HI")
                Text(shared.errorMessage)
                    .padding(.all, 30)
                    .multilineTextAlignment(.center)
                NavigationLink(destination: SignedIn(username: username), isActive: $signin) { EmptyView() }
                Button("Sign in"){
                    if (username.count==0 || password.count==0){
                        //errorMessage = "Username and password cannot be empty"
                        shared.errorMessage = "Username and password cannot be empty"
                        return
                    }
                    print("SIGNING IN with \(username) and \(password)")
                    if (signIn(userName:username, password:password)){
                        self.signin = true
                    }
                }.padding(.all, 20)
               // NavigationLink(destination: Text("Second View")) {
               //         Text("Hello, World!")
               // }
                //.navigationTitle("Navigation")
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
                    NavigationLink(destination: ChangePassword(username: username), isActive: $changePassword) { EmptyView() }
                    Button("Change Password"){
                        if (username.count==0 || password.count==0){
                            //errorMessage = "Username and password cannot be empty"
                            shared.errorMessage = "Username and password cannot be empty"
                            return
                        }
                        if (signIn(userName:username, password:password)){
                            changePassword = true
                        }
                        
                    }.padding(.all,20)
                    
                  //   Button("Populate 100"){
                        //WILL GET RID OF BUTTON BUT IT IS PRACTICAL FOR DEVELOPMENT
                        //populateUserInfoDB()
                        
                     //
                      //  shared.errorMessage = "Populating db with random orders successful"
                    //}.padding(.all,20)
                    //Spacer()
                }
                Spacer()
            }//.background(Color.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
