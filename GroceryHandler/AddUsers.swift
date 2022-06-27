//
//  AddUsers.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/27/22.
//

import SwiftUI

struct AddUsers: View {
    //if the user is in this view, he has logged in and provided a picture of a receipt
    
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
