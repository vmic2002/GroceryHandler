//
//  SignedIn.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/22/22.
//

import SwiftUI

struct SignedIn: View {
    @State var username:String
    var body: some View {
        Text("In Signed In VIEW \(username)")
    }
}

struct SignedIn_Previews: PreviewProvider {
    static var previews: some View {
        SignedIn(username:"Victor")
    }
}
