//
//  PastOrders.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/22/22.
//

import SwiftUI
//functional!
struct PastOrders: View {
    @State var username:String
    
    var body: some View {
        let orders = getAllOrdersForUserName(userName: username).orders.sorted(by: {
            $0.time.compare($1.time) == .orderedDescending//sorts so that newer orders are at the top
        })
        //dont need orders to be @state var because its value wont change in this view
        //if user goes back to signed in and posts an order when he comes back the getallorders fun will be called again so this page will be updated
        VStack{
            Text("\(orders.count) orders for \(username)")
                .padding(.all, 10)
                .font(.title)
                .foregroundColor(Color.gray)
            
            Form{
                ScrollView{
                    Text("")
                    ForEach(0 ..< orders.count) { value in
                        Text(getOrderAsString(order:orders[value]))
                            .multilineTextAlignment(.center)
                            
                    }
                }
                .font(.body)
                .frame(height:500)
                
            }
        }
        
    }
}

struct PastOrders_Previews: PreviewProvider {
    static var previews: some View {
        PastOrders(username:"username")
    }
}
