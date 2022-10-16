//
//  MainView.swift
//  NetsProject
//
//  Created by Hayden Ang on 16/10/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        SquareIconView(Color: .red, Text: "Game")
    }
}

struct SquareIconView : View {
    var Color: Color
    var Text: String
    
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var body: some View{
        NavigationView {
            VStack(alignment: .leading,spacing: 10){
                
                NavigationLink(destination: ContentView()){
                    (SwiftUI.Text("Learn ")+SwiftUI.Text(Image(systemName: "book.closed.fill")))
                    .font(.system(size: 40,design: .serif))
                    .frame(width: deviceWidth*0.9, height: deviceHeight*0.4)
                    .foregroundColor(.black)
                    .background(.green)
                    .cornerRadius(25)
                    
                    }
            
                (SwiftUI.Text("Play ")+SwiftUI.Text(Image(systemName: "play.fill"))+SwiftUI.Text("\n (To Be Implemented)"))
                    .font(.system(size: 40,design: .serif))
                    .multilineTextAlignment(.center)
                    .frame(width: deviceWidth*0.9, height: deviceHeight*0.4)
                    .foregroundColor(.black)
                    .background(.gray)
                    .cornerRadius(25)
                    .opacity(0.5)
                    
            }.navigationBarHidden(true)
        }
    }
}
    

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

