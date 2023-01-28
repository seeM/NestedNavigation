import SwiftUI

struct Folder: Hashable, Identifiable {
    var id = UUID()
    let name: String
    let contents: [Folder]
}

struct ContentView: View {
    let folder = Folder(name: "Root", contents: [
        Folder(name: "First", contents: [
            Folder(name: "Second", contents: [])
        ])
    ])

    var body: some View {
        NavigationStack {
            // WARNING: Update NavigationRequestObserver tried to update multiple times per frame.
            ZStack { // Why is this needed to make warning disappear?
                FolderView(folder: folder)
                    .navigationDestination(for: Folder.self) { folder2 in
                        FolderView(folder: folder2)
                    }
            }
        }
    }
}

struct FolderView: View {
    let folder: Folder

    var body: some View {
        List(folder.contents) { folder in
            NavigationLink(value: folder) {
                Text(folder.name)
            }
        }
    }
}
