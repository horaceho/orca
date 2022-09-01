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
    let icon: String
    let link: URL?
}

struct CloudView: View {
    @Binding var showiCloud: Bool
    @State var files: [File] = []
    @State var last_id: UUID = UUID()

    var body: some View {
        VStack() {
            List(files) { file in
                HStack {
                    Label(file.name, systemImage: file.icon)
                    Spacer()
                }
                .listRowBackground(file.id == last_id ? Color.gray.opacity(0.25) : Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    if let url = file.link {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        if file.icon == "folder" {
                            last_id = UUID()
                            clickFolder(name: file.name)
                        } else {
                            if file.id == last_id {
                                last_id = UUID()
                                clickFile(name: file.name)
                                showiCloud = false
                            } else {
                                last_id = file.id
                            }
                        }
                    }
                }
            }

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

//                Text("\(files.count)")
//                    .font(.caption)
//                    .padding()

                Spacer()

                Button(role: .none, action: {
                    showiCloud = false
                }) {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }.padding()
            }.padding(.horizontal)
        }
    }

    func rootUrl() -> URL? {
        if let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
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

        files = []
        files.append(File(
            name:"Please check the iCloud Drive sign in ...",
            icon: "exclamationmark.icloud",
            link: URL(string: UIApplication.openSettingsURLString)
        ))

        return nil
    }

    func refresh() {
        if let url = rootUrl() {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                let folderNames = contents.filter( \.hasDirectoryPath ).map{ $0.lastPathComponent }.sorted()
                let sgfFiles = contents.filter{ $0.pathExtension.lowercased() == "sgf" }
                let sgfNames = sgfFiles.map{ $0.deletingPathExtension().lastPathComponent }.sorted()
                files = []
                for folderName in folderNames {
                    files.append(File(
                        name: folderName,
                        icon: "folder",
                        link: nil
                    ))
                }
                for sgfName in sgfNames {
                    files.append(File(
                        name: sgfName,
                        icon: "circlebadge.2.fill",
                        link: nil
                    ))
                }
            } catch {
                print(error)
            }
        }
    }

    func random() {
        if let url = rootUrl() {
            let file = "\(UUID().uuidString).sgf"
            let data = "..."
            let url = url.appendingPathComponent(file)
            do {
                try data.write(to: url, atomically: false, encoding: .utf8)
            } catch {
                print(error)
            }
        }
    }

    func clickFolder(name: String) {
        print("Folder: \(name)")
    }

    func clickFile(name: String) {
        print("File: \(name)")
    }
}

struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView(showiCloud: .constant(true))
    }
}
