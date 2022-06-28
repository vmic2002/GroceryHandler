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
  //  @State private var errMsgColor = Color.red
    //https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui
    var body: some View {
        NavigationView {
            VStack{
                Text("Welcome to GroceryHandler")
                    .font(.title)
                    .foregroundColor(Color(red: 0, green: 0, blue: 0.5))
                //    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 70)
                    .padding(.bottom, 30)
                    .frame(height: 70)
                //COULD HAVE IMAGE OF LOGO HERE
                    //.background(Rectangle().stroke(Color.red, lineWidth: 10))
                        //RoundedRectangle(cornerRadius: 4).stroke())
                Spacer()
                //instead of spacer could put an image here
                
                // Form {
                HStack{
                    TextField("Username: ", text: $username)
                    //.padding(.all, 20)
                        .textFieldStyle(CustomTextField())
                        .onSubmit(){
                            //print("SIGNING IN with \(username) and \(password)")
                            shared.errorMessage = ""
                        }
                    Spacer()
                }
                HStack{
                    TextField("Password: ", text: $password)
                        .textFieldStyle(CustomTextField())
                        .onSubmit(){
                            //print("SIGNING IN with \(username) and \(password)")
                            shared.errorMessage = ""
                        }
                    Spacer()
                }
                // }
                //.frame(height: 199.0)
                //.padding(.bottom, 50)
                //.foregroundColor(Color.gray)
                //.moveDisabled(true)
                //.disabled(true)//to prevent scrolling
                //.background(Color.white)
                //Spacer()
                
                //Text("HI")
                Text(shared.errorMessage)
                    .padding(.all, 30)
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(shared.errMsgColor)
                NavigationLink(destination: SignedIn(username: username), isActive: $signin) { EmptyView() }
                Button("Sign in"){
                    if (username.count==0 || password.count==0){
                        //errorMessage = "Username and password cannot be empty"
                        shared.errMsgColor = Color.red
                        shared.errorMessage = "Username and password cannot be empty"
                        return
                    }
                    print("SIGNING IN with \(username) and \(password)")
                    if (signIn(userName:username, password:password)){
                        self.signin = true
                    }
                }//.padding(.all, 20)
                .multilineTextAlignment(.center)
                .padding(.all,5)
                .buttonStyle(CustomButton(color:Color(red: 0, green: 0, blue: 0.2)))
                HStack{
                    Button("Create Account"){
                        
                        if (username.count==0 || password.count==0){
                            //errorMessage = "Username and password cannot be empty"
                            shared.errMsgColor = Color.red
                            shared.errorMessage = "Username and password cannot be empty"
                            return
                        }
                        print("Creating account with \(username) and \(password)")
                        createAccount(userName: username, password: password)
                        print("Done created account")
                    }//.padding(.all, 20)
                    .multilineTextAlignment(.center)
                    .padding(.all,5)
                    .buttonStyle(CustomButton(color:Color(red: 0.2, green: 0.5, blue: 0.2)))
                    
                    Button("Delete Account"){
                        if (username.count==0 || password.count==0){
                            //  errorMessage = "Username and password cannot be empty"
                            shared.errMsgColor = Color.red
                            shared.errorMessage = "Username and password cannot be empty"
                            return
                        }
                        deleteAccount(userName: username, password: password)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.all, 5)
                    .buttonStyle(CustomButton(color: Color(red: 0.5, green: 0, blue: 0)))
                    NavigationLink(destination: ChangePassword(username: username), isActive: $changePassword) { EmptyView() }
                    Button("Change Password"){
                        if (username.count==0 || password.count==0){
                            //errorMessage = "Username and password cannot be empty"
                            shared.errMsgColor = Color.red
                            shared.errorMessage = "Username and password cannot be empty"
                            return
                        }
                        if (signIn(userName:username, password:password)){
                            changePassword = true
                        }
                        
                    }
                    .multilineTextAlignment(.center)
                    .padding(.all,5)
                    .buttonStyle(CustomButton(color:Color(red: 0, green: 0, blue: 0.5)))
                    // Button("DEV"){
                    
                    //  let currDate = Date()
                    //    print(currDate.formatted())
                    //     populateOrdersDB(numNewOrders: 100)
                    // }
                    //  .padding(.all, 20)
                    //   Button("Populate 100"){
                    //WILL GET RID OF BUTTON BUT IT IS PRACTICAL FOR DEVELOPMENT
                    //populateUserInfoDB()
                    
                    //
                    //  shared.errorMessage = "Populating db with random orders successful"
                    //}.padding(.all,20)
                    //Spacer()
                }
                Spacer()
            }.background(Color(red: 0.67, green: 0.87, blue: 0.9))
            //.background(Color(red: 0.96, green: 0.96, blue: 0.86))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
