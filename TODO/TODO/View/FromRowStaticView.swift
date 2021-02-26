//
//  FromRowStaticView.swift
//  TODO
//
//  Created by Muhammad Najwan Latief on 22/02/21.
//

import SwiftUI

struct FromRowStaticView : View {
    
    var icon : String
    var firstText : String
    var secondText: String
    
    var body: some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.gray)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }//Zstack
            .frame(width: 36, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(firstText)
                .foregroundColor(.black)
            Spacer()
            Text(secondText)
        }
    }
}

struct FromRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
        FromRowStaticView(icon: "gear", firstText: "General", secondText: "Todo")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
