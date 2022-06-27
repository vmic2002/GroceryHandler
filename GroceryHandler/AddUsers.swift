//
//  AddUsers.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/27/22.
//

import SwiftUI

struct AddUsers: View {
    //if the user is in this view, he has logged in and provided a picture of a receipt, which the ML function has taken and returned an array of prices
    //the app should ask the user to input list of users (this will be the columns
    //the app will let the user add/remove(since ML isnt perfect) a price (a price takes up a row)
    //there would be 2d array of checkboxed where each axis is the prices and the users
    
    @State var username:String
    @State var prices:[Double]
    var body: some View {
        VStack{
            Text("Hello, \(username)!")
            Text("Size of prices = \(prices.count)")
        }
    }
}

struct AddUsers_Previews: PreviewProvider {
    static var previews: some View {
        AddUsers(username: "userName", prices: [1.0,2.0])
    }
}
