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
    @State private var path: [Folder] = []
    @State private var selection: Folder.ID?

    var body: some View {
        NavigationSplitView {
            NavigationStack(path: $path) {
                FolderView(folder: folder, path: $path, selection: $selection)
                    .navigationDestination(for: Folder.self) { folder in
                        FolderView(folder: folder, path: $path, selection: $selection)
                    }
            }
        } detail: {
            if let obj = path.last {
                Text(obj.name)
            } else {
                Text("No selection")
            }
        }
    }
}

struct FolderView: View {
    let folder: Folder
    @Binding var path: [Folder]
    @Binding var selection: Folder.ID?
    
    var body: some View {
        List(folder.contents, selection: $selection) { folder in
            Text(folder.name)
        }
        .onChange(of: selection) { selection in
            if let selection {
                if let obj = folder.contents.first(where: { $0.id == selection }){
                    path.append(obj)
                }
            }
        }
    }
}
