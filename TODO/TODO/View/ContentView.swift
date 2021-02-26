import SwiftUI
 
struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: TODO.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TODO.name, ascending: true)]) var todos : FetchedResults<TODO>
    
    @EnvironmentObject var iconSetting : iconNames
    
    @State private var showingSettingView : Bool = false
    @State private var showingAddTodoView : Bool = false
    @State private var animatingButton : Bool = false
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes : [Theme] = themeData
    
    var body: some View {
        NavigationView{
          ZStack{
            List{
                ForEach(self.todos, id : \.self){ todo in
                    HStack{
                        Circle()
                            .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(self.colorIze(priority: todo.priority ?? "Normal"))
                        Text(todo.name ?? "Unknown")
                            .fontWeight(.semibold)
                        Spacer()
                        
                        Text(todo.priority ?? "Unknown")
                            .font(.footnote)
                            .foregroundColor(Color(UIColor.systemGray2))
                            .padding(3)
                            .frame(minWidth: 62)
                            .overlay(
                                Capsule() .stroke()
                            )
                    }//HStack
                    .padding(.vertical, 10)
                }
                .onDelete(perform: deleteTodo)
            }
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                trailing:
                
                                    Button(action: {self.showingSettingView.toggle()
                                    }){
                                        Image(systemName: "paintbrush")
                                            .imageScale(.large)
                                    }
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                .sheet(isPresented: $showingSettingView){
                    SettingsView().environmentObject(self.iconSetting)
                }
            )
            //ketika tidak ada item
            if todos.count == 0{
                EmptyListView()
            }
          } // ZStack
          .sheet(isPresented: $showingAddTodoView){
              AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
          }
          .overlay(
            ZStack{
                Group{
                    Circle()
                        .fill(Color.blue)
                        .opacity(self.animatingButton ? 0.2:0)
                        .scaleEffect(self.animatingButton ? 1:0)
                        .frame(width: 60, height: 88, alignment: .center)
                    Circle()
                        .fill(Color.blue)
                        .opacity(self.animatingButton ? 0.2:0)
                        .scaleEffect(self.animatingButton ? 1:0)
                        .frame(width: 60, height: 88, alignment: .center)
                }//Group
                .animation(Animation.easeInOut(duration:2).repeatForever(autoreverses: true))
                
                Button(action: {
                    self.showingAddTodoView.toggle()
                }){
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .background(Circle().fill(Color("Color Base")))
                    .frame(width: 48, height: 48, alignment: .center)
            }//Button
                .accentColor(themes[self.theme.themeSettings].themeColor)
                .onAppear(perform: {
                    self.animatingButton.toggle()
                })
            }//Zstack
            .padding(.bottom, 15)
            .padding(.trailing, 15)
            ,alignment:.bottomTrailing
          )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteTodo(at offsets: IndexSet){
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch{
                print(error)
            }
        }
    }//Func Delete
    private func colorIze(priority: String) ->Color{
        switch priority {
        case "High":
            return.red
        case "Normal":
            return.yellow
        case "Low":
            return.blue
        default:
            return.gray
        }
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext,context)
    }
}
 

