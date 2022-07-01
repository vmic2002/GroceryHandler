# Sample IOS app using Datastax Astra's Document API.

### Contributor:
[Victor Micha](https://github.com/vmic2002), Datastax Polaris Intern

### Objective:
Build an app in Swift that connects to the Datastax Astra Database

## About:
This sample app is coded in Swift and was developed on the XCode IDE. It connects to the Astra DB using the Document API. It handles user accounts (signing up, deleting accounts, etc) as well as shared orders/expenses. GroceryHandler is an application for facilitating the accounting of splitting expenses with others. For example, if roommates buy groceries together in one order, this app would be able to indicate how much each person owes the buyer. It also stores their user information as well as past orders.

## Prerequisites:
First, [create a Datastax Astra database account](https://auth.cloud.datastax.com/auth/realms/CloudUsers/protocol/openid-connect/registrations?client_id=auth-proxy&response_type=code&scope=openid+profile+email&redirect_uri=https://astra.datastax.com/welcome&).
For this sample project, the keyspace is named “keyspacename1” and the DB region is “us-east1”.
Follow instructions in the Connect tab of the Astra website to generate an Application Token: 
![](READMEPictures/Screen%20Shot%202022-06-30%20at%204.44.44%20PM.png)
Make sure to keep track of these variables: 
```
ASTRA_DB_ID, ASTRA_DB_REGION, ASTRA_DB_KEYSPACE, ASTRA_DB_APPLICATION_TOKEN
```
Next, [Download XCode](
https://developer.apple.com/xcode/).

The XCode version for this application is version 13.4.1.



## How to replicate project:
See -> [Prerequisites first](https://github.com/vmic2002/GroceryHandler/edit/master/README.md#prerequisites)
Go to the directory where you would like your project to reside. Clone the project by running:
```bash
$ git clone https://github.com/vmic2002/GroceryHandler.git
```
This is all that is needed to strictly connect to the database. However, the sample app uses ML Kit Text Recognition API to decipher prices from receipts. The Pods required for this are too big to be stored on Github, so either follow the steps to integrate them in your project by [clicking here](https://github.com/vmic2002/GroceryHandler#integrate-pods-in-project) or remove them from project by [clicking here](https://github.com/vmic2002/GroceryHandler#if-you-only-want-your-app-to-connect-to-the-astra-db-and-not-use-ml-or-pods-follow-these-steps).
#### Integrate Pods in Project:
1. In the same window, go to your project directory by running 
```bash
$ cd GroceryHandler
```
2. To install CocoaPods, run: 
```bash
$ sudo gem install cocoapods
```
3. To edit the Podfile, run:
```bash
$ vim Podfile
```
Under  
```
# Pods for <APP_NAME>
```
add (it should already be there):
```
pod 'GoogleMLKit/TextRecognition','2.2.0'
```
To install the Pods directory, exit the Podfile and run:
```bash
$ pod install
```

![](READMEPictures/Screen%20Shot%202022-06-30%20at%204.44.02%20PM.png)

Now the pods are installed and the project will build once opened on XCode!

#### If you only want your app to connect to the Astra DB and not use ML or Pods, follow these steps:
1. After cloning the git repo, go to your project directory by running:
```bash
$ cd GroceryHandler
```
2. Run these commands to remove the pods from the project:
```bash
$ sudo gem install cocoapods-deintegrate cocoapods-clean
$ pod deintegrate
$ pod cache clean --all
$ rm Podfile
```
3. Make sure to comment out the MLTextRecognizer.swift file once you are in XCode because the import statements will cause problems if the Pods were deleted successfully

#### !! Whether you chose to remove the Pods or keep them, now follow the following steps. !!


Launch the XCode app and select “Open a project or file”
![](READMEPictures/Screen%20Shot%202022-06-30%20at%204.45.29%20PM.png)

Click on the GroceryHandler.xcworkspace file and select Open
![](READMEPictures/Screen%20Shot%202022-06-30%20at%204.46.19%20PM.png)



Build the project and run the app. [Click here](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device) to run it on your personal device.

## How to connect to your own database in the app:
If you would like to connect to your Astra DB from your app, follow these steps:
Change the 
```
ASTRA_DB_ID, ASTRA_DB_REGION, ASTRA_DB_APPLICATION_TOKEN
```
variables in the DBController.swift file in this function:
```swift
func httpRequest(httpMethod: String, endUrl: String)-> URLRequest {
 //...
}
```
The httpMethods are “PUT”, “DELETE”, “POST”, “PATCH”, or “GET”
The endUrl is of the form (depending on the httpMethod):
```
/namespaces/{namespace}/collections/{collection-id}
```

Now you should create your own collection using Swagger UI:
![](READMEPictures/Screen%20Shot%202022-06-30%20at%204.46.48%20PM.png)

The collections for the sample app are named: “userInfo” and “orders”. They are both in the keyspace “keyspacename1”. For your app to connect to your database, make sure to change (in the DBController.swift file) the “userInfo”, “orders”, and “keyspacename1” to whatever you named them.

## Additional Information

### Sending requests to a server in Swift:
The [JSONEncoder](https://developer.apple.com/documentation/foundation/jsonencoder) class makes it easy to convert a struct into a JSON type which can then be posted to a collection of the Astra DB. The [URLRequest](https://developer.apple.com/documentation/foundation/urlrequest) struct and [URLSession](https://developer.apple.com/documentation/foundation/urlsession) class handle the request to the server.

### Using Document API to connect to your Astra DB:
The URL to connect to your Astra db using the Document API is : 
```
https://ASTRA_DB_ID-ASTRA_DB_REGION.apps.astra.datastax.com/api/rest/v2/namespaces/ASTRA_DB_KEYSPACE/collections/{collection-id}
```
Check out the [Astra DB documentation](https://docs.datastax.com/en/astra/docs/develop/dev-with-doc.html) for more information.

### For beginners to Swift: 
[Click here](https://developer.apple.com/tutorials/swiftui)

### For beginners to databases:
Make sure to do some research on HTTP requests, URLs, and JSON.

### Interested in using the ML in your own app?
[Click here](https://developers.google.com/ml-kit/vision/text-recognition/ios) and/or look at the MLTextRecognizer.swift file
