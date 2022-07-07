//
//  FinalizePrices.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/27/22.
//

import SwiftUI

struct FinalizePrices: View {
    //if the user is in this view, he has logged in and provided a picture of a receipt, which the ML function has taken and got an array of prices
    //this view is to finalize the list of prices in case ML wasnt 100% successful
    @State var username:String
    @State var prices:[Double]
    @State private var price:String = ""
    @State private var errMsg = ""//"Error: Invalid input"
    @State private var errMsgColor = Color.red
    var body: some View {
        VStack{
            ScrollView{
                
                Text("Number of prices = \(prices.count)")
                ForEach(0 ..< prices.count, id: \.self) { value in
                    // Text("\(prices[value])")
                    Text(String(format: "%.2f", prices[value]))//.2f -> 2 decimal points`
                        .multilineTextAlignment(.center)
                    
                }
            }
            .background(Color(red: 0.3, green: 0.6, blue: 0.8))
            .cornerRadius(5)
            .frame(height: 200)
            .font(.callout)
            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.9))
            .padding(.top, 25)
            Spacer()
            
            Text(errMsg)
                //.padding(.all, 5)
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(errMsgColor)
                //.frame(width:280, height:40)
            
            TextField("Enter price (rounded to 2 decimal places):", text: $price)
                .textFieldStyle(CustomTextField())
            HStack{
                Button("Add Price"){
                    if var newPrice = Double(price){//NEED TO TRUNCATE LEAVE ONLY 2 DECIMAL SPACES
                        
                        if (newPrice>0 && newPrice<300){
                            //newPrice has to be < 300 is arbitrary
                            //this is also the case in MLTextRecognizer
                            newPrice = Double(round(100*newPrice)/100)//round to 2 decimal spots
                            prices.append(newPrice)
                            //print("Price \(newPrice) added")
                            errMsgColor = Color.green
                            errMsg = "Price \(newPrice) added"
                            price = ""
                            return
                        } else {
                            //print("Price \(newPrice) not in valid range")
                            errMsgColor = Color.red
                            errMsg = "Price \(newPrice) not in valid range"
                            price = ""
                            return
                        }
                    }
                    //print("Please input a valid price")
                    errMsgColor = Color.red
                    errMsg = "Please input a valid price"
                    price = ""
                }
                .multilineTextAlignment(.center)
                .padding(.all,15)
                .buttonStyle(CustomButton(color:Color(red: 0, green: 0, blue: 0.2)))
                Button("Remove Price"){
                    if var newPrice = Double(price){
                        if (newPrice>0 && newPrice<300){
                            //newPrice has to be < 300 is arbitrary
                            //this is also the case in MLTextRecognizer
                           newPrice = Double(round(100*newPrice)/100) //round 2 decimals spots
                            let ind = prices.firstIndex(of: newPrice)
                            if !(ind==nil){
                                prices.remove(at: ind!)
                                //print("Price \(newPrice) removed")
                                errMsgColor = Color.green
                                errMsg = "Price \(newPrice) removed"
                            } else {
                                //print("Price \(newPrice) not found in list")
                                errMsgColor = Color.red
                                errMsg = "Price \(newPrice) not found in list"
                                
                            }
                            price = ""
                            return
                        }
                        //print("Price \(newPrice) not in valid range")
                        errMsgColor = Color.red
                        errMsg = "Price \(newPrice) not in valid range"
                        price = ""
                        return
                    }
                   // print("Didnt input valid price")
                    errMsgColor = Color.red
                    errMsg = "Please input a valid price"
                    price = ""
                }
                .multilineTextAlignment(.center)
                .padding(.all,15)
                .buttonStyle(CustomButton(color:Color(red: 0.5, green: 0, blue: 0)))
            }
            
        }
        .background(Color(red: 0.67, green: 0.87, blue: 0.9))
   
    }
}

struct FinalizePrices_Previews: PreviewProvider {
    static var previews: some View {
        FinalizePrices(username: "userName", prices: [1.0,2.0])
    }
}
