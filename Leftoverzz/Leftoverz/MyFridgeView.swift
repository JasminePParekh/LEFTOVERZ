//
//  MyFridgeView.swift
//  Leftoverz
//
//  Created by Johann Antisseril on 4/24/23.
//

import Foundation
import SwiftUI

struct MyFridgeView: View {
    @ObservedObject var fridge = Fridge()
    var body: some View {
        VStack {
            Text("My Fridge")
                .font(.title)
                .fontWeight(.semibold)
            
            List(fridge.fridgeList, id: \.name) {
                food in HStack {
                    //                food.image
                    //                    .resizable()
                    //                    .frame(width: 50, height: 50)
                    Text("\(food.name), Expires On: \(food.expireDate.formatted(date: .numeric, time: .omitted))")
                }.listRowBackground(backgroundColor(date: food.expireDate))
            }
            
            Button(action:addAction){
                Text("Add Ingredient")
            }
            .padding(0.0)
        }
    }
}
func addAction() {
    //activate camera
}
func backgroundColor(date:Date) -> Color {
    let daysTilExpire = date.distance(to: Date())
    switch (daysTilExpire) {
    case 3...5: return .yellow
    case 1...3: return .red
    case ...1: return .gray
    default:
        return .green
    }
}
struct MyFridgeView_Previews: PreviewProvider {
    static var previews: some View {
        MyFridgeView()
    }
}

