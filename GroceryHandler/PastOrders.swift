//
//  PastOrders.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/22/22.
//

import SwiftUI

struct PastOrders: View {
    @State var username:String
    var body: some View {
        Text("Hello, \(username)!")
    }
}

struct PastOrders_Previews: PreviewProvider {
    static var previews: some View {
        PastOrders(username:"username")
    }
}
