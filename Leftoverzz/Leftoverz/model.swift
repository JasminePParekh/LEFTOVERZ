//
//  model.swift
//  Leftoverz
//
//  Created by Johann Antisseril on 4/24/23.
//

import Foundation

class Fridge: ObservableObject {
    struct Food {
        var name:String
        var expireDate:Date
        //var image
        
    }
    @Published var fridgeList:[Food] = [Food(name:"Apple", expireDate: Date()), Food(name:"Banana", expireDate: Date())]
    func addItem(itemName:String, dateExpire:Date) {
        fridgeList.append( Food(name: itemName, expireDate: dateExpire) )
    }
    
    
}
