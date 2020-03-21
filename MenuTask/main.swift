//
//  main.swift
//  MenuTask
//
//  Created by Seif Elmenabawy on 3/16/20.
//  Copyright © 2020 Seif Elmenabawy. All rights reserved.
//

import Foundation


var cart = [Int:Int]() //itemIndex:qty

//Creating the MenuItem Struct with a simplified _ init
struct MenuItem {
var name: String
var price: Int
    
    init(_ name: String,_ price: Int) {
        self.name = name
        self.price = price
    }
}


func getPrice(itemIndex: Int) -> Int{
    menu[itemIndex].price
}


func calculateTotal(){
    var totalCost = 0
    for cartItem in cart{
        totalCost += getPrice(itemIndex: cartItem.key) * cartItem.value
    }
    print("Total is \(totalCost) EGP 💳 Type checkout to end the session\n")
}


func viewCart(){
    print("🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒")
    for cartItem in cart{
        print("\(menu[cartItem.key].name) -> \(cartItem.value) -> \(cartItem.value * getPrice(itemIndex: cartItem.key)) EGP")
    }
    print("🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒")
}

func addToCart(_ orderList: String){
    //create an array with ordered items
    let orderedItemsArray = orderList.components(separatedBy: ",")

    //loop through the items array, analyze the qty and add it to the cart (counted set)
    for orderedItem in orderedItemsArray{
       guard var itemIndex = Int(orderedItem.components(separatedBy: "$")[0]) else {print("Formatting Error");return;}
       guard let itemCount = Int(orderedItem.components(separatedBy: "$")[1]) else {print("Formatting Error");return;}
       itemIndex-=1;
        if !menu.indices.contains(itemIndex){print("Unknown Menu Item \(itemIndex+1)");continue;}
        cart[itemIndex] = (cart[itemIndex] ?? 0) + itemCount
    }
    
    viewCart();
    calculateTotal();
    print("Type DELETE@1 to delete all Classic Burger Sandwiches or DELETE1@$1 to delete only 1 Classic Burger sandwich\nTo Save the cart type \"anazboon\"")
    return
}

func removeFromCart(_ orderList: String){
    var orderList = orderList
    orderList = orderList.replacingOccurrences(of: "DELETE@", with: "")
    // the user requested to delete a certain qty
    if(orderList.contains("$")){
        guard var itemIndex = Int(orderList.components(separatedBy: "$")[0]) else {print("Formatting Error");return;}
        guard let itemCount = Int(orderList.components(separatedBy: "$")[1]) else {print("Formatting Error");return;}
        itemIndex-=1;
        if cart[itemIndex] == nil {print("There aren't any \(menu[itemIndex].name) in the cart ");return;}
        cart[itemIndex] = (cart[itemIndex] ?? 0) - itemCount
    }
    // the user requested to delete an item regardless of it's qty
    else{
    guard var itemIndex = Int(orderList) else {print("Formatting Error");return;}
    if cart[itemIndex] == nil {print("There aren't any \(menu[itemIndex].name) in the cart ");return;}
    itemIndex-=1
    cart.removeValue(forKey: itemIndex)
    }
    viewCart();
    calculateTotal();
}

//creating a dummy menu in an array (Array of structs)
var menu = [MenuItem("Classic Burger",10),MenuItem("Cheese Burger",20),MenuItem("Double Burger",15),MenuItem("Double Cheese Burger",25),MenuItem("Burger El Teneen",35)]


//printing the menu
for i in 0..<menu.count{
    print("\(i+1)-\(menu[i].name): \(menu[i].price)")
}
 print("-----------------------------------------")



print("Write chosen sandwich followed by $ then the count. e.g. 1$2 to order 2 Classic burgers\nAdd more sandwiches by putting a comma e.g. 1$2,2$1 to order 2 Classic burgers & 1 Cheese burger\nTo fetch a saved cart type ORDER$ followed by the customer name e.g. ORDER$seif")

//infinute loop waiting for customer input
while(true){
    //handling unexpected spaces in user input
    guard let orderList = readLine()?.replacingOccurrences(of: " ", with: "") else {
        print("Formatting Error!")
        break;
    }
    
    if(orderList.contains("checkout")){
        cart.removeAll()
        print("Thanks for ordering 👋🏼, Next Customer")
    }
    else if(orderList.contains("DELETE@")){
            removeFromCart(orderList)
    }
    else if(orderList.contains("anazboon")){
        print("Enter Customer Name to save: ", terminator:"")
        guard let customerName = readLine()?.replacingOccurrences(of: " ", with: "") else {
            print("Formatting Error!")
            break;
        }
        let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: cart, requiringSecureCoding: false)
        UserDefaults.standard.set(encodedData, forKey: customerName)
    }
    else if(orderList.contains("ORDER$")){
        if UserDefaults.standard.object(forKey: orderList.replacingOccurrences(of: "ORDER$", with: "")) == nil {print("Cannot find this customer");continue;}
        let decoded  = UserDefaults.standard.object(forKey: orderList.replacingOccurrences(of: "ORDER$", with: "")) as! Data
        cart = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [Int:Int]
        viewCart();
        calculateTotal();
    }
    else if(orderList.contains("$")){
        addToCart(orderList)
    }

}
