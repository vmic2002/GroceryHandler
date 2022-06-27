
//
//  GroceryHandlerApp.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/13/22.
//

import SwiftUI

import simd
//import MLKitTextRecognition

import AVFoundation
//import ReplayKit

@main
struct GroceryHandlerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct Item : Codable {
    
    let price : Double
    let users : [String]
}
//structs used to PATCH -> change paid status or change password
struct Paid :Codable {
    var paid :Bool
}
struct Password: Codable{
    var password:String
}

struct Order : Codable {
    let userName : String
   // let password : String
    //let payerName : String -> use userName instead
    let receipt : [Item]
    var paid : Bool
}

struct UserInfo : Codable {
    let userName : String
    let password : String
}

var orders = [Order]()//has to be global because getRequest is async
var gotOrders = false//same reason as above
var localOrderDB = [String:Order]()

var gotUserInfo = false
var localUserInfoDB = [String:UserInfo]()

var gotPrices = false
var prices = [Double]()

//var errorMessage:String = "Error message"

let userNames = ["Michael1", "Dwight1", "Jim1", "Pam1", "Angela1", "Kevin1",
             "Oscar1", "Phillys1", "Stanley1", "Andy1", "Toby1", "Kelly1",
             "Ryan1", "David1", "Gabe1", "Robert1", "Creed1", "Roy1", "Darryl1",
             "Jan1", "Holly1", "Mose1", "Joe1"]

func buttonTapped(n:Int) -> String {
    print("tapped")
    //USED AS MAIN FUNCTION

    //createAccount(userName: "Andy1", password: "itsdrewnow")
    
    //deleteAccount(userName: "Andy1")
    //populateUserInfoDB()

    //printUserInfoFor(userName: "Andy1")
    
  //  for name in userNames {
    //    printUserInfoFor(userName: name)
   // }
    
    //populateOrdersDB(numNewOrders: 200)
    //deleteOrdersForUserName(userName: "Michael1", numOrders: 2)
  //  let docID = "a4272914-74f0-4379-a60a-cc8a440a58a7"
   // deleteOrderRequest(docID: "52dfd13c-0411-48c2-ab47-68bb09178e2a")
    
   // deleteOrdersForUserName(userName: "Michael1", numOrders:8)
       //printAllOrdersFor(userName: "Michael1")
    //  print(getSetOfNames())
   // printAllOrdersFor(userName: "Michael1")
    //populateOrdersDB(numNewOrders: 200)
    // // print("Average is \(getAverageNumBytesOfDoc())")
    //let order = Order(userName: "Andy1", receipt: [Item(price: 10, users: ["Andy1", "Michael1"])])
   //var dict = [String:Double]()
   // postRequest(order: order)
  //  computeAmountOwed(order: order, dict: &dict)
//computeAllOrdersFor(userName:"Andy1")
    
    //printAllOrdersFor(userName:"Victor")
    //printOrders(orders: getOrdersWhereTotalIs(total: 510.045, userName: "Michael1"))
    return "hi"
}


func getAverageNumBytesOfDoc()->Int{
    let numNewOrders = 50//arbitrary
    var sum = 0
    for _ in 0..<numNewOrders{
        let order = getRandomOrder(userNames: Array(getRandomSetOfUserNames()))
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let uploadData = try? encoder.encode(order) else {
            break
            //could not convert to type data
        }
        print(uploadData)
        /// print(Int(uploadData.count))
        sum+=Int(uploadData.count)
        //printOrder(order: order)
        
    }
    //print("Average is \(sum/numNewOrders)")
    return sum/numNewOrders
}


func getRandomSetOfUserNames()->Set<String>{
    let numUserNames = Int.random(in: 2..<userNames.count/3)
    var setOfUserNames = Set<String>()
    for _ in 0..<numUserNames {
        var randInt = Int.random(in: 0..<userNames.count)
        while (setOfUserNames.contains(userNames[randInt])){
            randInt = Int.random(in: 0..<userNames.count)
        }
        setOfUserNames.insert(userNames[randInt])
    }
    return setOfUserNames
}

func getRandomOrder(userNames:[String])->Order{
    //userNames has length of at least 2
    //userNames shoudl be list of DISTINCT strings
    //example:["Arthur2", "Marie123", "Victor12"]
    //one of these will be the user who pays
    let payerNameIndex = Int.random(in: 0..<userNames.count)
    var receipt = [Item]()
    let numItems = Int.random(in: 2...15)//2...15 is arbitrary and small for testing, could make much bigger though
    for _ in 0..<numItems{
        let numUsers = Int.random(in: 1...userNames.count)
        var setOfIndices = Set<Int>()
        for _ in 0..<numUsers {
            //get a name from names randomly
            var index = Int.random(in: 0..<userNames.count)
            while (setOfIndices.contains(index)){
                index = Int.random(in: 0..<userNames.count)
                //to prevent repeat names
            }
            setOfIndices.insert(index)
        }
        var users = [String]()
        for i in setOfIndices{
            users.append(userNames[i])
        }
        let price = Double.random(in: 0.5...50.0)
        let priceRounded = round(price*1000)/1000
        let item = Item(price: priceRounded, users: users)//0.5...50.0 is arbitrary
        receipt.append(item)
    }
    let order = Order(userName:userNames[payerNameIndex], receipt:receipt, paid: false)
    return order
}


func printAllOrdersFor(userName:String){
    let orders1 = getAllOrdersForUserName(userName: userName).orders
    print("there are \(orders1.count) orders")
    printOrders(orders: orders1)
}

func printUserInfoFor(userName:String){
    let userInfoDict1 = getUserInfoForUserName(userName: userName)
    if (userInfoDict1.count==0){
        print("No account with username: \(userName)")
        return
    }
    for (_,userInfo) in userInfoDict1 {
        print("Username: \(userInfo.userName), Password: \(userInfo.password)")
        //for loop should only iterate once because usernames are unique
    }
}

//returns an order summary
func computeAmoundOwed(order:Order)->String{
    var dict = [String:Double]()
    computeAmountOwed(order: order, dict: &dict)
    var result = ""
    for (key,value) in dict{
        result+="\(key) owes \(value) to \(order.userName) \n"
    }
    return result
}

func computeAmountOwed(order:Order, dict: inout [String:Double]){
    //need dictionary of ["user":amountOwed]
    //dont need to count for user that is payerName
    //function could return dictionary
    print("start of compute amount owed method")
    //printOrder(order:order)
    //var dict = [String:Double]()
    for item in order.receipt{
        let amount = Double(item.price)/Double(item.users.count)
        for user in item.users {
            if (user != order.userName){
                //no need to keep track how much the person paid owes themselves
                //this is assuming that every person has a different name
                if (dict[user]==nil){
                    dict[user]=0.0
                }
                dict[user]!+=Double(amount)//truncatetruncate
            }
        }
    }
    //each user owes dict[user] to order.userName
    //for (key,value) in dict{
   //     print("\(key) owes \(value) to \(order.userName)")
   // }
    print("end of compute amound owed method")
    //  return dict
}

func printOrder(order:Order){
    print("Payer user name: \(order.userName)")
    //print("Receipt: ")
    for item in order.receipt {
        //print("item price: \(item.price)")
        print("\(item.price)")
        //print("User: ", terminator: "")
        // for user in item.users {//
        //     print("\(user) ", terminator: "")
        // }
        // print()
    }
    
}

func printOrders(orders:[Order]){
    for order in orders {
        printOrder(order:order)
    }
}

