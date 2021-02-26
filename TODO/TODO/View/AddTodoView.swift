import SwiftUI
 
struct AddTodoView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name : String = ""
    @State private var priority : String = "Normal"
    
    let priorities = ["High", "Normal", "Low"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle : String = ""
    @State private var errorMassage : String = ""
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes : [Theme] = themeData
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    TextField("Todo", text: $name)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding()
                        .background(Color(UIColor.tertiaryLabel))
                        .cornerRadius(9)
                        
                    
                    
                    Picker("Priority", selection: $priority){
                        ForEach(priorities, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Button(action: {
                        if self.name != ""{ // klw data name terisi
                            let todo = TODO(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            do{
                                try self.managedObjectContext.save()
                                //print("New Todo : \(todo.name ?? "") , priority : \(todo.priority ?? "")")
                            }catch{
                                print(error)
                            }
                        }else { // klw data name kosong
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMassage = "Jangan di kosongkan!!!"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Simpan")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth:0 ,maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .background(Color.blue)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
            }
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark.diamond")
                }
            )
            .alert(isPresented: $errorShowing){
                Alert(title: Text(errorTitle), message: Text(errorMassage),dismissButton: .default(Text("OK")))
            }
        }
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
 
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
