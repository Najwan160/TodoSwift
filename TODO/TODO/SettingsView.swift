//
//  SettingsView.swift
//  TODO
//
//  Created by Muhammad Najwan Latief on 22/02/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var iconSetting : iconNames
    
    let themes:[Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    @State private var isThemeChanged: Bool = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0){
                
                Form{
                    
                    Section(header: Text("Choose the AppIcon")){
                        Picker(selection: $iconSetting.currentIndex, label:Text("App icons")){
                            ForEach(0..<iconSetting.iconNames.count){index in
                                HStack{
                                    Image(uiImage: UIImage(named: self.iconSetting.iconNames[index] ?? "Green") ?? UIImage())
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    Spacer().frame(width: 8)
                                    
                                    Text(self.iconSetting.iconNames[index] ?? "Green")
                                        .frame(alignment: .leading)
                                    
                                    
                                }//HStack
                                .padding(3)
                            }
                        }//Picker
                        .onReceive([self.iconSetting.currentIndex].publisher.first()){
                            (value) in
                            let index = self.iconSetting.iconNames.firstIndex(of: UIApplication.shared.alternateIconName)
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSetting.iconNames[value]){error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }else{
                                        print("Berhasil mengubah icon")
                                    }
                               }
                           }
                      }
                    }
                    .padding(.vertical, 3)
                    
                    Section(header:
                                HStack{
                                    Text("Choose App Theme")
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width:10, height:10)
                                        .foregroundColor(themes[self.theme.themeSettings].themeColor)
                                }
                    )//Header
                    {
                        List{
                            ForEach(themes,id: \.id){ item in
                                Button(action:{
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                    self.isThemeChanged.toggle()
                                }){
                                    HStack{
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        
                                        Text(item.themeName)
                                    }
                                }//Image Button
                                .accentColor(Color.primary)
                            }
                        }
                    }//Section
                    .padding(.vertical, 3)
                    .alert(isPresented: $isThemeChanged){
                        Alert(
                            title: Text("Success"),
                            message: Text("Applikasi berhasil di ubah \(themes[self.theme.themeSettings].themeName)!"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Section(header: Text("Follow us on Social Media")){
                        FromRowLinkView(icon: "globe", color: Color.pink, text: "Youtube", link: "https://youtube.com/")
                        FromRowLinkView(icon: "envelope", color: Color.blue, text: "Email", link: "https://mail.google.com/mail/u/0/")
                        FromRowLinkView(icon: "link", color: Color.green, text: "Website", link: "https://yandex.com/")
                }//Link
                    .padding(.vertical, 3)
                    
                    Section(header: Text("About Application")){
                        FromRowStaticView(icon: "gear", firstText: "General", secondText: "Todo")
                        FromRowStaticView(icon: "checkmark.seal", firstText: "Compability", secondText: "Iphone / Ipad")
                        FromRowStaticView(icon: "keyboard", firstText: "Keyboard", secondText: "default")
                        FromRowStaticView(icon: "paintbrush", firstText: "Application", secondText: "Todo")
                        FromRowStaticView(icon: "flag", firstText: "Version", secondText: "1.1.0")
                    }
            }//Form
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                Text("Copyright ❤️ All 2021")//ctrl + cmd + space
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 6)
                    .foregroundColor(Color.secondary)
        }//VStack
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark")
            }
            )//NavigationBar
            .navigationBarTitle("Setting", displayMode: .inline)
            .background(Color("ColorBackground"))
            .edgesIgnoringSafeArea(.all)
        }
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(iconNames())
    }
}
