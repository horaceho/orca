//
//  CloudView.swift
//  Orca
//
//  Created by Horace Ho on 31/8/2022.
//

import SwiftUI

struct File: Identifiable {
    let id = UUID()
    let name: String
    let isDirectory: Bool
}

struct CloudView: View {
    @Binding var showiCloud: Bool
    @State var files: [File] = []

    var body: some View {
        List(files) {
            Label($0.name, systemImage: $0.isDirectory ? "folder" : "circlebadge.2.fill")
        }

        Spacer()

        HStack {
            Button(role: .none, action: {
                refresh()
            }) {
                Image(systemName: "arrow.clockwise.icloud")
                    .imageScale(.large)
            }.padding()

            Button(role: .none, action: {
                random()
                refresh()
            }) {
                Image(systemName: "text.badge.plus")
                    .imageScale(.large)
            }.padding()

            Text("\(files.count)").font(.caption).padding()

            Spacer()

            Button(role: .none, action: {
                showiCloud = false
            }) {
                Image(systemName: "arrow.uturn.backward.circle")
                    .imageScale(.large)
            }.padding()
        }
    }

    func rootUrl() -> URL {
        let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents")
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error)
            }
        }
        return url
    }

    func refresh() {
        let url = rootUrl()
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            let folderNames = contents.filter( \.hasDirectoryPath ).map{ $0.lastPathComponent }.sorted()
            let sgfFiles = contents.filter{ $0.pathExtension.lowercased() == "sgf" }
            let sgfNames = sgfFiles.map{ $0.deletingPathExtension().lastPathComponent }.sorted()
            files = []
            for folderName in folderNames {
                files.append(File(name: folderName, isDirectory: true))
            }
            for sgfName in sgfNames {
                files.append(File(name: sgfName, isDirectory: false))
            }
        } catch {
            print(error)
        }
    }

    func random() {
        let file = "\(UUID().uuidString).sgf"
        let data = "..."
        let url = rootUrl().appendingPathComponent(file)
        do {
            try data.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView(showiCloud: .constant(true))
    }
}
