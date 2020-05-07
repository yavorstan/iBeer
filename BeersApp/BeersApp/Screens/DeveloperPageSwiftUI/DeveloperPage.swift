//
//  DeveloperPage.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import SwiftUI
import SCLAlertView

@available(iOS 13.0.0, *)
struct DeveloperPage: View {
    
    let popupManager = PopupManager()
    
    var body: some View {
        ZStack{
            SwiftUIBackgroundView()
            
            ScrollView {
                VStack {
                    Text(NSLocalizedString("str_developer_page", comment: ""))
                        .foregroundColor(Color(UIColor.DefaultTextColor.color!))
                        .font(Font(UIFont.defaultTitleFont.font))
                        .bold()
                        .padding(.bottom, 50)
                        .padding(.top, 20)
                    Image("yavor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150, alignment: .center)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(UIColor.DefaultAppColor.color!), lineWidth: 9)
                    )
                    
                    SwiftUILabel(text: DeveloperModel.name, font: Font(UIFont.defaultTitleFont.font))
                        .padding(.top, 10)
                    SwiftUILabel(text: DeveloperModel.jobTitle, font: Font(UIFont.defaultDescriptionFont.font))
                        .padding(.bottom, 40)
                    
                    SwiftUIInfoView(text: DeveloperModel.phoneNumber, imageName: "phone.fill")
                        .overlay(
                            Button(action: {
                                self.popupManager.showConfirmPopup(title: NSLocalizedString("str_warning", comment: ""), message: NSLocalizedString("str_phone_popup", comment: ""))
                                self.popupManager.yesTapped = { () in
                                    self.openURL(to: "TEL://\(DeveloperModel.phoneNumber)")
                                }
                            }) {
                                Text("")
                                    .frame(width: 350, height: 30, alignment: .center)
                            }
                    )
                    SwiftUIInfoView(text: DeveloperModel.email, imageName: "envelope.fill")
                        .overlay(
                            Button(action: {
                                self.popupManager.showConfirmPopup(title: NSLocalizedString("str_warning", comment: ""), message: NSLocalizedString("str_email_popup", comment: ""))
                                self.popupManager.yesTapped = { () in
                                    self.openURL(to: "mailto:\(DeveloperModel.email)")
                                }
                            }) {
                                Text("")
                                    .frame(width: 350, height: 30, alignment: .center)
                            }
                    )
                        .padding(.top, -30)
                    SwiftUIInfoView(text: DeveloperModel.linkedIn, imageName: "globe")
                        .overlay(
                            Button(action: {
                                self.popupManager.showConfirmPopup(title: NSLocalizedString("str_warning", comment: ""), message: NSLocalizedString("str_linkedin_popup", comment: ""))
                                self.popupManager.yesTapped = { () in
                                    self.openURL(to: "https://\(DeveloperModel.linkedIn)")
                                }
                            }) {
                                Text("")
                                    .frame(width: 350, height: 30, alignment: .center)
                            }
                    )
                        .padding(.top, CGFloat(-30))
                        .padding(.bottom, CGFloat(-20))
                }
            }
        }
    }
    
    //MARK: Util Methods
    func openURL(to string: String) {
        if let url = URL(string: string),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

@available(iOS 13.0, *)
struct DeveloperPage_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperPage()
        
    }
}
