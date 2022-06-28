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
        //could only get orders that arent paid, or only orders that have been paid using order.paid
        //dont need orders to be @state var because its value wont change in this view
        //if user goes back to signed in and posts an order when he comes back the getallorders fun will be called again so this page will be updated
        VStack{
            Text("\(orders.count) orders for \(username)")
                .padding(.all, 10)
                .font(.title)
                .foregroundColor(Color.gray)
            
           // VStack{
                ScrollView{
                    Text("")
                    ForEach(0 ..< orders.count) { value in
                        Text(getOrderAsString(order:orders[value]))
                            .multilineTextAlignment(.center)
                            
                    }
                }
                .font(.body)
                .frame(height:500)
                
           // }.background(Color.red)
        }
        
        .background(Color(red: 0.67, green: 0.87, blue: 0.9))
        
    }
}

struct PastOrders_Previews: PreviewProvider {
    static var previews: some View {
        PastOrders(username:"username")
    }
}
