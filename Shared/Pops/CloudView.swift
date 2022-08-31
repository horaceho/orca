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
}

struct CloudView: View {
    @Binding var showiCloud: Bool
    @State var files: [File] = []

    var body: some View {
        List(files) {
            Text($0.name)
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
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            let txtFiles = contents.filter{ $0.pathExtension == "txt" }
            let txtNames = txtFiles.map{ $0.lastPathComponent }
            files = []
            for txtName in txtNames {
                files.append(File(name: txtName))
            }
        } catch {
             print(error)
        }
    }

    func random() {
        let file = "\(UUID().uuidString).txt"
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
