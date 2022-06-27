//
//  SignedIn.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/22/22.
//

import SwiftUI

struct SignedIn: View {
    @State var username:String
    @State var items = [Item]()
    //  @State private var prices = Set<Double>()
    @State private var users = Set<String>()
    @State private var user: String = ""
    //@State private var payer:String = ""
    @State private var price: String = ""
    @State private var errMsg = ""
    @State private var orderSummary = ""
    @State private var orderStr = ""
    @State private var pastOrders = false
    @State private var pictureReceipt = false
    var body: some View {
        //Text("In Signed In VIEW \(username)")
        // NavigationView{
      
        VStack{
            NavigationLink(destination: PictureReceipt(username:username), isActive: $pictureReceipt){EmptyView()}
            Text("Hello, \(username)")
                .font(.title)
                .foregroundColor(Color.green)
                .multilineTextAlignment(.center)
                //.padding(.all, 10)
            
            Form{
                HStack{
                    Spacer()
                    Text(errMsg)
                        .padding(.all, 30)
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundColor(Color.red)
                        .frame(width:280, height:50)
                    Spacer()
                }
                .frame(height:50)
                HStack{
                    TextField("Enter user:", text:$user)
                        .padding(.all, 20)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Button("Add User"){
                        if (user.count==0){
                            //errorMessage = "Username and password cannot be empty"
                            errMsg = "user cannot be empty"
                            return
                        }
                        ///CHECK THAT USER IS A VALID USER NAME AND THAT IT HAS NOT ALREADY BEEN ENTERER IN USERS  TO SET
                        // ADD IT TO USERS SET
                        if (getUserInfoForUserName(userName: user).count==0){
                            errMsg = "no account found for: \(user)"
                            return
                        }
                        if (users.contains(user)){
                            errMsg = "\(user) already added"
                            return
                        }
                        users.insert(user)
                        errMsg = "\(user) added to users"
                    }.padding(.all, 10)
                }
                HStack{
                    TextField("Enter price:", text:$price)
                        .padding(.all, 20)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Button("Add Item"){
                        if (price.count==0){
                            //errorMessage = "Username and password cannot be empty"
                            errMsg = "Price is empty!"
                            return
                        }
                        if (users.count==0){
                            errMsg = "Num users = 0"
                            return
                        }
                        //if price is valid double
                        var pr = 0.0
                        if let p = Double(price) {
                            //errMsg = "The user entered a value pr ice of \(p)"
                            pr = p
                        } else {
                            errMsg = "Not a valid number: \(price)"
                            return
                        }
                        let us = Array(users)
                        items.append(Item(price: pr, users: us))
                        errMsg = "Added item: price \(pr) and numUsers: \(users.count)"
                        user = ""
                        price = ""
                        users.removeAll()
                    }
                    .padding(.all, 10)
                }
                
                HStack{
                    Spacer()
                    Button("Take picture of receipt instead"){
                        //GO TO NEW VIEW WHERE TAKING PICTURE WITH CAMERA AND ML IS DONE to get prices
                        //WILL ALSO HAVE TO ASK USER WHO USED WHAT PRODUCT to get users
                        //then post order/compute
                      //  errMsg = "Coming soon!"
                        pictureReceipt = true
                    }
                    Spacer()
                }.frame(height:60)
                
            }
            .frame(height: 350)
            .padding(.bottom, 10)
            
            NavigationLink(destination: PastOrders(username:username), isActive: $pastOrders){EmptyView()}
            Button("See past orders"){
                pastOrders = true
            }
            .padding(.all, 10)
            .frame(height: 20)
            ScrollView{
                Text(orderStr) 
                   // .padding(.all, 5)
                    .multilineTextAlignment(.center)
                Text(orderSummary)
                   // .padding(.all, 5)
                    .multilineTextAlignment(.center)
                   // .frame(width:320, height:150)
                    //.lineLimit(30)
            }
            Button("Post order and view summary"){
                if (items.isEmpty){
                    errMsg = "No items were added."//An order must have at least 1 item"
                    orderSummary = ""
                    orderStr = ""
                    return
                }
                let order = Order(userName: username, receipt: items, paid: false, time: Date().formatted())
                //Date().formatted() : 6/27/2022, 1:44 PM
                postRequest(order: order)
                errMsg = "Order posted to db"
                user = ""
                price = ""
                items.removeAll()
                users.removeAll()
                orderSummary = computeAmoundOwed(order: order)
                orderStr = getOrderAsString(order: order)
                
            }.padding(.all, 10)
            Button("Clear all entries"){
                user = ""
                //payer = ""
                price = ""
                items.removeAll()
                users.removeAll()
                errMsg = ""
                orderSummary = ""
                orderStr = ""
            }
            .foregroundColor(Color.gray)
            .padding(.all, 10)
        }
        //   }
    }
}

struct SignedIn_Previews: PreviewProvider {
    static var previews: some View {
        SignedIn(username:"userName")
    }
}
