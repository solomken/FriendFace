//
//  ContentView.swift
//  FriendFace
//
//  Created by Anastasiia Solomka on 23.08.2023.
//

import SwiftUI

struct Response: Codable {
    var results: [User]
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var users: FetchedResults<CachedUser>
    
    var body: some View {
        NavigationView {
            List(users, id: \.id) { user in
                NavigationLink {
                        DetailView(user: user)
                } label: {
                    HStack {
                        Text("\(user.wrappedName)")
                        
                        Circle()
                            .fill(user.isActive ? .green : .gray)
                            .frame(width: 10)
                    }
                }
            }
            .navigationTitle("FriendFace")
            .task {
                await loadData() //we can comment this line to check if our cache is working (after the first success run)
            }
        }
    }
    
    func loadData() async {
        guard users.isEmpty else { return }
        
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let users = try decoder.decode([User].self, from: data)
            //updateCache(with: users) - we can not do it bc Swift will try to check updates along with building view (async) so it can cause app crash. we need to use main actor for cache update func
            
            await MainActor.run {
                updateCache(with: users) // this will ensure the main actor runs the Core Data code, and therefore can’t also be refreshing the SwiftUI body – the two cannot happen at the same time.
            }
        } catch {
            print("Download failed")
        }
    }
    
    func updateCache(with downloadedUsers: [User]) {
        for user in downloadedUsers {
            let cachedUser = CachedUser(context: moc)
            cachedUser.id = user.id
            cachedUser.isActive = user.isActive
            cachedUser.name = user.name
            cachedUser.age = Int16(user.age)
            cachedUser.company = user.company
            cachedUser.email = user.email
            cachedUser.address = user.address
            cachedUser.about = user.about
            cachedUser.registered = user.registered
            cachedUser.tags = user.tags.joined(separator: ",")
            
            for friend in user.friends {
                let cachedFriend = CachedFriend(context: moc)
                cachedFriend.id = friend.id
                cachedFriend.name = friend.name
                
                cachedUser.addToFriend(cachedFriend)
            }
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
