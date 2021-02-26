import SwiftUI
 
struct EmptyListView: View {
    
    @State private var isAnimated : Bool = false
    
    let images: [String] = [
        "illustration-no1",
        "illustration-no2",
        "illustration-no3"
    ]
    
    let tips: [String] = [
        "RPL D",
        "SMK IDN"
    ]
     
    @ObservedObject var theme = ThemeSettings.shared
    var themes : [Theme] = themeData
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing:20){
                Image("\(images.randomElement() ?? self.images[0])")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                Text("\(tips.randomElement() ?? self.tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            } // VStack
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y:isAnimated ? 0 : -50)
            .animation(.easeOut(duration:1.5))
            .onAppear(perform: {
                self.isAnimated.toggle()
            })
        } // ZStack
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight:.infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}
 
struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .environment(\.colorScheme, .dark)
    }
}
 


