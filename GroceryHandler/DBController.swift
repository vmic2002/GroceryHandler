//
//  DBController.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/20/22.
//
//handles interaction to astra database
import Foundation


class ErrorManager: ObservableObject {
    //taken/copied from https://stackoverflow.com/questions/59312795/a-state-static-property-is-being-reinitiated-without-notice
    @Published var errorMessage: String = ""
}

let shared = ErrorManager()


//for a user to sign up (create account)
func createAccount(userName:String, password:String){
    let userInfoDict = getUserInfoForUserName(userName: userName)
    if (userInfoDict.count>0){
       // ContentView.setErrMsg("Cannot create account with username: \(userName) because one already exists.")
        shared.errorMessage = "Cannot create account with username: \(userName) because one already exists."
        print("Cannot create account with username: \(userName) because one already exists.")
        return
    }
    postRequest(userInfo: UserInfo(userName: userName, password: password))
    shared.errorMessage = "Account created successfully"
}


func deleteAccount(userName:String, password:String){
    shared.errorMessage = "Deleting acount... Please wait"
    //BUG!!
    //change of errormessage not showing up in view because
    //view gets updated once function is over
    
    //get user info and doc id from astra db
    let localUserInfoDB = getUserInfoForUserName(userName: userName)
    //returns dict of docID:UserInfo
    //because doc id is needed to delete from db
    //for loop DELETES USER INFO
    //WHICH IS DELETING ACCOUNT
    if (localUserInfoDB.count==0){
        shared.errorMessage = "Cannot delete account with username: \(userName) because none exists."
        print("Cannot delete account with username: \(userName) because none exists.")
        return
    } 
    
    for (docID, userInfo) in localUserInfoDB {
        if (userInfo.password==password){
            deleteUserInfoRequest(docID: docID)
        } else {
            shared.errorMessage = "Incorrect password. Cannot delete account."
            print("Incorrect password. Cannot delete account.")
        
            return
        }
        //for loop should only iterate once because usernames should be unique
    }
    
    
    //now to delete all orders with this username
    
    //deleteOrdersForUserName deletes 20 max orders so we need the while loop to delete all
    var db = getAllOrdersForUserName(userName: userName).localOrderDB
    while (!(db.count==0)){
       print("Deleting orders")
        for (docID, _) in db {
            deleteOrderRequest(docID: docID)
        }
        db = getAllOrdersForUserName(userName: userName).localOrderDB
        //deleteOrdersForUserName(userName: userName)//deletes 20 accounts max`
    }
    
    shared.errorMessage = "Account deleted successfully"
    
}

func deleteOrdersForUserName(userName:String){
    /*
     get all orders for username and get all their DOC IDs
     then go through each ID and delete
     */
    let localOrderDB = getAllOrdersForUserName(userName: userName).localOrderDB//to get doc ID because can only delete from database with doc ID (at least from what I know)
    for (docID, _) in localOrderDB {
        deleteOrderRequest(docID: docID)
    }
}

//if user has lots of receipts he wants to compute in one go
func computeAllOrdersFor(userName:String){
    let orders1 = getAllOrdersForUserName(userName: userName).orders
    var dict = [String:Double]()
    for order in orders1{
        computeAmountOwed(order: order, dict: &dict)
    }
    for (key,value) in dict{
        print("\(key) owes \(value) to \(userName)")
    }
}

func populateUserInfoDB(){
    createAccount(userName: "Michael1", password: "thatswhatshesaid")
    createAccount(userName: "Dwight1", password: "bearsbeetsbattlestargallactica")
    createAccount(userName: "Jim1", password: "beesley!")
    createAccount(userName: "Pam1", password: "sprinkleofcinnamon")
    createAccount(userName: "Angela1", password: "cats")
    createAccount(userName: "Kevin1", password: "cookies")
    createAccount(userName: "Oscar1", password: "accountant")
    createAccount(userName: "Phillys1", password: "damnitphyllis")
    createAccount(userName: "Stanley1", password: "crosswordpuzzles")
    createAccount(userName: "Andy1", password: "itsdrewnow")
    createAccount(userName: "Toby1", password: "goingtocostarica")
    createAccount(userName: "Kelly1", password: "attention")
    createAccount(userName: "Ryan1", password: "hottestintheoffice")
    createAccount(userName: "David1", password: "corporate")
    createAccount(userName: "Gabe1", password: "birdman")
    createAccount(userName: "Robert1", password: "lizardking")
    createAccount(userName: "Creed1", password: "scrantonstrangler")
    createAccount(userName: "Roy1", password: "wharehouseandpam")
    createAccount(userName: "Darryl1", password: "rogers")
    createAccount(userName: "Jan1", password: "loveshunter")
    createAccount(userName: "Holly1", password: "michaelslove")
    createAccount(userName: "Mose1", password: "dwightsbrother")
    createAccount(userName: "Joe1", password: "ceoofsabre")
}

func populateOrdersDB(numNewOrders:Int){
    for _ in 0..<numNewOrders{
        let order = getRandomOrder(userNames: Array(getRandomSetOfUserNames()))
        postRequest(order: order)
    }
}

//get all UserInfo where username = something in real time
func getUserInfoForUserName(userName:String)-> [String:UserInfo]{
    getRequestUserInfo(userName:userName)
    //userinfo isnt computed even after getRequestUserInfo is finished
    //need while loop
    while gotUserInfo==false{
        Thread.sleep(forTimeInterval: 1)
        //after while loop orders will be complete
    }
    print("there are \(localUserInfoDB.count) user infos with username: \(userName)")
    
   
    var localUserInfoDBCpy = [String:UserInfo]()
    for (docID, userInfo) in localUserInfoDB {
        
        localUserInfoDBCpy[docID] = UserInfo(userName: userInfo.userName, password: userInfo.password)
        //for loop should iterate just once because usernames are unique
        //structs are passed as copies
    }
    //reinitialize gotOrders and orders and localOrderDB
    gotUserInfo = false
    localUserInfoDB.removeAll()
    return localUserInfoDBCpy
}

/*
 get all orders where userName = something in real time
 so that a user can see all past orders
 */
func getAllOrdersForUserName(userName:String)->(orders: [Order], localOrderDB: [String:Order]) {
    getRequestOrders(userName:userName, maxNumOrders: 20)
    //max number of orders to get back is 20 -> max num of docs that can be returned
    //orders isnt computed even after getRequestOrders is finished
    //need while loop
    while gotOrders==false{
        Thread.sleep(forTimeInterval: 1)
        //after while loop orders will be complete
    }
    print("there are \(orders.count) orders")
    // printOrders()
    var ordersCpy = [Order]()
    var localOrderDBCpy = [String:Order]()
    for (docID, order) in localOrderDB {
        ordersCpy.append(Order(userName: order.userName, receipt: order.receipt))
        localOrderDBCpy[docID] = Order(userName: order.userName, receipt: order.receipt)
        //structs are passed as copies
    }
    //reinitialize gotOrders and orders and localOrderDB
    gotOrders = false
    orders = [Order]()
    localOrderDB.removeAll()
    return (ordersCpy, localOrderDBCpy)
}

//orderOrUserInfo is true to perform order get request
//and false to perform user info get request
func getRequest(orderOrUserInfo:DarwinBoolean, str:String){
    let request = httpRequest(httpMethod: "GET", endUrl: str)
    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        if let error = error {
            //shared.errorMessage = "error: \(error)"
            
            print (shared.errorMessage)
            return
        }
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            //shared.errorMessage = "server error"
            //COMMENTED line above because of bug:Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
            print (shared.errorMessage)
            //print(response)
            return
        }
        if let mimeType = response.mimeType,
           mimeType == "application/json",
           let data = data,
           var dataString = String(data: data, encoding: .utf8) {
              // print ("got data: \(dataString)")
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
            if (orderOrUserInfo==true){
                typealias Values = [String: Order]
                if let jsonData = dataString.data(using: .utf8) {
                    let events = try? JSONDecoder().decode(Values.self, from: jsonData)
                    for (key, eventData) in events! {
                        //event data should be an Order
                        //key should be a docID
                        // print("KEY: "+key + " NAME: " + eventData.payerName)
                        localOrderDB[key]=eventData
                        orders.append(eventData)
                    }
                    gotOrders = true
                } else {
                    print("Could not convert to type Data")
                    shared.errorMessage = "Error occured while fetching from database"
                }
            } else {
                typealias Values = [String: UserInfo]
                if let jsonData = dataString.data(using: .utf8) {
                    let events = try? JSONDecoder().decode(Values.self, from: jsonData)
                    for (key, eventData) in events! {
                        //event data should be an UserInfo
                        //key should be a docID
                        // print("KEY: "+key + " NAME: " + eventData.payerName)
                        localUserInfoDB[key]=eventData
                        //localUserInfoDB is dictionary even though we only expect the number of entries to be at most one
                        //since usernames are unique
                    }
                    gotUserInfo = true
                } else {
                    print("Could not convert to type Data")
                    shared.errorMessage = "Error occured while fetching from database"
                }
                
            }
            
        }
    }
    task.resume()
    //print("end of get request method")
}

//can be used to know if a doc with a certain username exists
//helps to know if account already exists
func getRequestUserInfo(userName:String){
    let str = "/namespaces/keyspacename1/collections/userInfo?where={\"userName\":{\"$eq\":\"\(userName)\"}}&page-size=1"
    getRequest(orderOrUserInfo: false, str: str)
}

//sets correct values to orders and localOrderDB vars
func getRequestOrders(userName:String, maxNumOrders:Int){
    //param is username of person to retrieve all orders
    //print("in get request method"+">> /namespaces/keyspacename1/collections/orders?where=\\{\"firstname\":\\{\"$eq\":\""+name+"\"\\}\\}")
    // let str = "/namespaces/keyspacename1/collections/orders?where=\\{\"payerName\":\\{\"$eq\":\"\(name)\"\\}\\}"
    let str = "/namespaces/keyspacename1/collections/orders?where={\"userName\":{\"$eq\":\"\(userName)\"}}&page-size=\(maxNumOrders)"
    //print("str is:"+str)
    getRequest(orderOrUserInfo: true, str: str)
    
}

func postRequest(uploadData:Data, collection:String){
    /*swagger UI link to use *post* a *document* using Document API:
     https://ASTRA_DB_ID-ASTRA_DB_REGION.apps.astra.datastax.com/api/rest/v2/namespaces/{namespace-id}/collections/{collection-id}
     */
    let request = httpRequest(httpMethod: "POST", endUrl: "/namespaces/keyspacename1/collections/\(collection)")
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            shared.errorMessage = "error: \(error)"
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            shared.errorMessage = "server error"
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
           mimeType == "application/json",
           let data = data,
           let _ = String(data: data, encoding: .utf8) {
           //let dataString = String(data: data, encoding: .utf8) {
            print("POST to \(collection) successful")
            if (collection.elementsEqual("userInfo")){
                //shared.errorMessage = "Account created successfully"
                print("Account created successfully")
            }
            //print ("got data: \(dataString)")
            
            //dataString is of form:
            /*
             {"documentId":"58171bbd-cd42-4c54-a5f7-ed146097d1dc"}
             */
        }
    }
    task.resume()
    //print("end of post request method")
}

//creates account for user with userInfo
func postRequest(userInfo:UserInfo){
    //print("in post request method")
    //to turn userInfo into JSON
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let uploadData = try? encoder.encode(userInfo) else {
        return
        //could not convert to type data
    }
    // print("Here is JSON uploadData:")
    //print(String(data: uploadData, encoding: .utf8)!)
    postRequest(uploadData: uploadData, collection: "userInfo")
}

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
    postRequest(uploadData: uploadData, collection: "orders")
}

func getOrdersWhereTotalIs(total:Double, userName:String)->[Order]{
    let orders1 = getAllOrdersForUserName(userName: userName).orders
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

func deleteUserInfoRequest(docID:String){
    deleteRequest(docID: docID, collectionID: "userInfo")
}

func deleteOrderRequest(docID:String){
    deleteRequest(docID: docID, collectionID: "orders")
}

func deleteRequest(docID:String, collectionID:String){
    let request = httpRequest(httpMethod: "DELETE", endUrl: "/namespaces/keyspacename1/collections/\(collectionID)/\(docID)")
    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        if let error = error {
            shared.errorMessage = "error: \(error)"
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            shared.errorMessage = "server error"
            print ("server error")
            return
        }
       //shared.errorMessage = "Account deleted successfully"
        //comment line above because of bug: Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
    }
    task.resume()
    //print("end of delete doc function")
}
