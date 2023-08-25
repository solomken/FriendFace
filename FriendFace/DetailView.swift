//
//  DetailView.swift
//  FriendFace
//
//  Created by Anastasiia Solomka on 23.08.2023.
//

import SwiftUI

struct DetailView: View {
    let user: CachedUser
    
    var body: some View {
        VStack {
            HStack {
                Text("\(user.wrappedName)")
                Circle()
                    .fill(user.isActive ? .green : .gray)
                    .frame(width: 10)
            }
            .font(.title)
            .padding(30)
            List {
                Section {
                    Text(user.wrappedEmail)
                } header: {
                    Text("Email")
                }
                
                Section {
                    Text(user.wrappedAddress)
                } header: {
                    Text("Address")
                }
                
                Section {
                    Text("\(user.wrappedRegistered)")
                } header: {
                    Text("Registered at")
                }
                
                Section {
                    Text(user.wrappedCompany)
                } header: {
                    Text("Company")
                }
                
                Section {
                    Text(user.wrappedAbout)
                } header: {
                    Text("Info")
                }
                
                Section {
                    if user.friendArray.isEmpty {
                        Text("No friends yet 🥺")
                    } else {
                        ForEach(user.friendArray) { friend in
                            Text(friend.wrappedName)
                        }
                    }
                } header: {
                    Text("Friends")
                }
            }
            .listStyle(.grouped)
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(user: User.example)
//    }
//}
