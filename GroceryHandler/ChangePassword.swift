//
//  ChangePassword.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/23/22.
//

import SwiftUI

struct ChangePassword: View {
    @State var username:String
    @State var errMsg = ""
    @State var newPassword:String = ""
    var body: some View {
        VStack{
            Text("Hey \(username)!")
                .font(.title)
                .foregroundColor(Color.cyan)
                .padding(.top, 70)
            Spacer()
            Text(errMsg)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.green)
            TextField("New password here", text: $newPassword)
                .padding(.all, 20)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            HStack{
                Spacer()
                Button("Change Password"){
                    if (newPassword.count==0){
                        errMsg = "New password cannot be empty"
                        return
                    }
                    changePassword(newPassword: newPassword, userName: username)
                    errMsg = "Password changed to \(newPassword)"
                    newPassword = ""
                    //change passowrd here
                }.padding(.top, 10)
            }
            Spacer()
            
        }
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword(username:"userName")
    }
}
