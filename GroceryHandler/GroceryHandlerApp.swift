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

struct Order : Codable {
    let payerName : String
    let receipt : [Item]
}

let names = ["Michael", "Dwight", "Jim", "Pam", "Angela", "Kevin",
             "Oscar", "Phillys", "Stanley", "Andy", "Toby", "Kelly",
             "Ryan", "David", "Gabe", "Robert", "Creed", "Roy", "Darryl",
             "Jan", "Holly", "Mose", "Joe"]

var orders = [Order]()//has to be global because getRequest is async
var gotOrders = false//same reason as above

var localDB = [String:Order]()

func buttonTapped(n:Int) -> String {
    print("tapped")
    
     //deleteOrdersForName(name: "Michael", numOrders: 2)
  //  let docID = "a4272914-74f0-4379-a60a-cc8a440a58a7"
    //deleteOrderRequest(docID: docID)
    
    //deleteOrdersForName(name: "Andy", numOrders: 1)
    //   printAllOrdersFor(name: "Andy")
    //  print(getSetOfNames())
    //printAllOrdersFor(name: "Andy")
    //populateDatabase(numNewOrders: 200)
    // // print("Average is \(getAverageNumBytesOfDoc())")
    //computeAmountOwed(order: order, dict: &dict)
    //computeAllOrdersFor(name:"Andy")
    //printAllOrdersFor(name:"Victor")
    //printOrders(orders: getOrdersWhereTotalIs(total: 25.2, payerName: "Marie"))
    return "hi"
}

func populateDatabase(numNewOrders:Int){
    for _ in 0..<numNewOrders{
        let order = getRandomOrder(names: Array(getRandomSetOfNames()))
        postRequest(order: order)
    }
}

func getAverageNumBytesOfDoc()->Int{
    let numNewOrders = 50
    var sum = 0
    for _ in 0..<numNewOrders{
        let order = getRandomOrder(names: Array(getRandomSetOfNames()))
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


func getRandomSetOfNames()->Set<String>{
    
    let numNames = Int.random(in: 2..<names.count/3)
    var setOfNames = Set<String>()
    for _ in 0..<numNames {
        var randInt = Int.random(in: 0..<names.count)
        while (setOfNames.contains(names[randInt])){
            randInt = Int.random(in: 0..<names.count)
        }
        setOfNames.insert(names[randInt])
    }
    return setOfNames
}

func getOrdersWhereTotalIs(total:Double, payerName:String)->[Order]{
    let orders1 = getAllOrdersForPayerName(payerName: payerName).orders
    var result = [Order]()
    for order in orders1 {
        var sum = 0.0
        for item in order.receipt{
            sum+=item.price
        }
        if (sum == total){
            result.append(order)
        }
    }
    return result
}

func getRandomOrder(names:[String])->Order{
    //names has length of at least 2
    //names shoudl be list of DISTINCT strings
    //example:names:["Arthur", "Marie", "Victor"]
    //one of these will be payerName
    let payerNameIndex = Int.random(in: 0..<names.count)
    var receipt = [Item]()
    let numItems = Int.random(in: 2...15)//2...15 is arbitrary and small for testing, could make much bigger though
    for _ in 0..<numItems{
        let numUsers = Int.random(in: 1...names.count)
        var setOfIndices = Set<Int>()
        for _ in 0..<numUsers {
            //get a name from names randomly
            var index = Int.random(in: 0..<names.count)
            while (setOfIndices.contains(index)){
                index = Int.random(in: 0..<names.count)
                //to prevent repeat names
            }
            setOfIndices.insert(index)
        }
        var users = [String]()
        for i in setOfIndices{
            users.append(names[i])
        }
        let price = Double.random(in: 0.5...50.0)
        let priceRounded = round(price*1000)/1000
        let item = Item(price: priceRounded, users: users)//0.5...50.0 is arbitrary
        receipt.append(item)
    }
    let order = Order(payerName:names[payerNameIndex], receipt:receipt)
    return order
}


func printAllOrdersFor(name:String){
    let orders1 = getAllOrdersForPayerName(payerName: name).orders
    print("there are \(orders1.count) orders")
    printOrders(orders: orders1)
}


//if user has lots of receipts he wants to compute in one go
func computeAllOrdersFor(name:String){
    let orders1 = getAllOrdersForPayerName(payerName: name).orders
    var dict = [String:Double]()
    for order in orders1{
        computeAmountOwed(order: order, dict: &dict)
    }
    for (key,value) in dict{
        print("\(key) owes \(value) to \(name)")
    }
}

func getAllOrdersForPayerName(payerName:String)->(orders: [Order], localDB: [String:Order]) {
    getRequest(name:payerName, maxNumOrders: 15)
    //max number of orders to get back is arbitrarily 20
    //if this number is too big we will get a server error
    //orders isnt computed even after getRequest is finished
    //need while loop
    while gotOrders==false{
        Thread.sleep(forTimeInterval: 1)
        //after while loop orders will be complete
    }
    print("there are \(orders.count) orders")
    // printOrders()
    var ordersCpy = [Order]()
    var localDBCpy = [String:Order]()
    for (docID, order) in localDB {
        ordersCpy.append(Order(payerName: order.payerName, receipt: order.receipt))
        localDBCpy[docID] = Order(payerName: order.payerName, receipt: order.receipt)
        //structs are passed as copies
    }
    //reinitialize gotOrders and orders and localDB
    gotOrders = false
    orders = [Order]()
    localDB.removeAll()
    return (ordersCpy, localDBCpy)
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
            if (user != order.payerName){
                //no need to keep track how much the person paid owes themselves
                //this is assuming that every person has a different name
                if (dict[user]==nil){
                    dict[user]=0.0
                }
                dict[user]!+=Double(amount)
            }
        }
    }
    //each user owes dict[user] to order.payerName
    for (key,value) in dict{
        print("\(key) owes \(value) to \(order.payerName)")
    }
    print("end of compute amound owed method")
    //  return dict
}

func printOrder(order:Order){
    print("Payer name: \(order.payerName)")
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


/*
 get all orders where payerName = something
 so that a user can see all past orders
 */

func postRequest(order:Order){
    //print("in post request method")
    //to turn order into JSON
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let uploadData = try? encoder.encode(order) else {
        return
        //could not convert to type data
    }
    // print("Here is JSON uploadData:")
    //print(String(data: uploadData, encoding: .utf8)!)
    /*swagger UI link to use *post* a *document* using Document API:
     https://ASTRA_DB_ID-ASTRA_DB_REGION.apps.astra.datastax.com/api/rest/v2/namespaces/{namespace-id}/collections/{collection-id}
     */
    let request = httpRequest(httpMethod: "POST", endUrl: "/namespaces/keyspacename1/collections/orders")
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
           mimeType == "application/json",
           let data = data,
           let dataString = String(data: data, encoding: .utf8) {
            //   print ("got data: \(dataString)")
            print("P")
            //dataString is of form:
            /*
             {"documentId":"58171bbd-cd42-4c54-a5f7-ed146097d1dc"}
             */
        }
    }
    task.resume()
    //print("end of post request method")
}



func deleteOrderRequest(docID:String){
    //tested this function it seems to work well
    let request = httpRequest(httpMethod: "DELETE", endUrl: "/namespaces/keyspacename1/collections/orders/\(docID)")
    
    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
    }
    task.resume()
    print("end of delete doc function")
}



func deleteOrdersForName(name:String, numOrders:Int){
    /*
     get all orders for name and get all their ID
     then go through each ID (numOrders amount of times) and delete
     */
    let localDB = getAllOrdersForPayerName(payerName: name).localDB//to get doc ID because can only delete from database with doc ID (at least from what I know)
    var i = 0
    for (docID, _) in localDB {
        if (i>=numOrders) {
            break
        }
        deleteOrderRequest(docID: docID)
        i+=1
    }
}


func getRequest(name:String, maxNumOrders:Int){
    //param is name of person to retrieve all orders where "payerName" == name
    //print("in get request method"+">> /namespaces/keyspacename1/collections/orders?where=\\{\"firstname\":\\{\"$eq\":\""+name+"\"\\}\\}")
    // let str = "/namespaces/keyspacename1/collections/orders?where=\\{\"payerName\":\\{\"$eq\":\"\(name)\"\\}\\}"
    let str = "/namespaces/keyspacename1/collections/orders?where={\"payerName\":{\"$eq\":\"\(name)\"}}&page-size=\(maxNumOrders)"
    //print("str is:"+str)
    let request = httpRequest(httpMethod: "GET", endUrl: str)
    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            print ("server error")
            print(response)
            return
        }
        if let mimeType = response.mimeType,
           mimeType == "application/json",
           let data = data,
           var dataString = String(data: data, encoding: .utf8) {
            //   print ("got data: \(dataString)")
            /*
             JSON data is of the form
             {“data”:
             {
             “docID”: Order,
             “docID”:Order
             }
             }
             OR
             {"pageState":"JDZjN2Y5MGQ5LWYyZGItNGRkNS05Mzk3LTZiNDE5NzYzNGMwZQDwf_____B_____","data":{
             
             “docID”: Order,
             “docID”:Order
             }
             }
             */
            //TO SOLVE PROBLEM FIND FIRST OCCURENCE OF DATA, PAGE STATE SHOULD ESSENTIALLY NEVER HAVE WORD DATA IN IT WOUKLD
            //BE VERY UNLUCKY
            //  let indx = dataString.firstIndex(of: "data")
            //  dataString.index
            // let indx = dataString.firstIndex(of: <#T##Character#>)
            
            let str = "data"
            var j = 0
            var indx = dataString.startIndex//arbitrary
            for i in 2..<dataString.count {
                if (dataString[dataString.index(dataString.startIndex, offsetBy: i)]==str[str.index(str.startIndex, offsetBy: j)]){
                    if (j<3){
                        //i is incremented because of for loop
                        j+=1
                    } else {//if j==3 then str has been found in dataString
                        //indx = i + 3
                        indx = dataString.index(dataString.startIndex, offsetBy: i+3)
                        break
                    }
                } else {
                    if (!(j==0)) {
                        j=0//if mismatch set j back to 0
                    }
                }
            }
            //indx is at start of desired JSON string
            
            
            //get substirng of dataString from indx to endIndex-1 (or remove last char after)
            //DO THIS!!!!
            let x = dataString.startIndex..<indx
            dataString.removeSubrange(x)
            dataString.removeLast()//to remove last }
            //  print("dataString should be nicely formatted now")
            //  print("dataString: \(dataString)")
            /*
             by now dataString is of form:
             {
             “docID”: Order,
             “docID”:Order
             }
             */
            //https://medium.com/@boguslaw.parol/decoding-dynamic-json-with-unknown-properties-names-and-changeable-values-with-swift-and-decodable-127e437e8000
            typealias Values = [String: Order]
            if let jsonData = dataString.data(using: .utf8) {
                let events = try? JSONDecoder().decode(Values.self, from: jsonData)
                for (key, eventData) in events! {
                    //event data should be an Order
                    //key should be a docID
                    // print("KEY: "+key + " NAME: " + eventData.payerName)
                    localDB[key]=eventData
                    orders.append(eventData)
                }
                gotOrders = true
            } else {
                print("Could not convert to type Data")
            }
        }
    }
    task.resume()
    print("end of get request method")
}

func httpRequest(httpMethod: String, endUrl: String)-> URLRequest {
    /*
     code for this function is taken/copied from : https://developer.apple.com/documentation/foundation/url_loading_system/uploading_data_to_a_website
     */
    // print("start of httprequest method")
    let ASTRA_DB_ID = "29293b22-592c-41b5-8070-ef494732113e";
    let ASTRA_DB_REGION = "us-east1";
    let token = "AstraCS:mJoYxZFcsmFTSqvKiiHXfGCy:343a2715d03d5c22e435d1da6929c7d7d239c78c1d0d35e2548ba5cf749f0385"
    
    //print("endURL is: "+endUrl)
    // print("https://"+ASTRA_DB_ID+"-"+ASTRA_DB_REGION+".apps.astra.datastax.com/api/rest/v2"+endUrl)
    let str = "https://"+ASTRA_DB_ID+"-"+ASTRA_DB_REGION+".apps.astra.datastax.com/api/rest/v2"+endUrl
    //let url = URL(string: str)!
    let encodedStr = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    // print("encodedStr = \(encodedStr)")
    
    let url = URL.init(string:encodedStr)! //"https://"+ASTRA_DB_ID+"-"+ASTRA_DB_REGION+".apps.astra.datastax.com/api/rest/v2/namespaces/keyspacename1/collections/orders")!
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod//"POST" or "GET
    if (httpMethod=="POST"){
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue(token, forHTTPHeaderField: "X-Cassandra-Token")
    // print("end of httprequest method")
    return request
}
