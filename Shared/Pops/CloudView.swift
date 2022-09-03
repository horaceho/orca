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
    @EnvironmentObject var match: Match
    @State var files: [File] = []
    @State var lastId: UUID = UUID()
    @State var pathUrl: URL?

    var body: some View {
        VStack() {
            List(files) { file in
                ZStack {
                    HStack {
                        Label(file.name, systemImage: file.icon)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let url = file.link {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            if file.icon == "folder" {
                                lastId = UUID()
                                clickFolder(name: file.name)
                            } else {
                                if file.id == lastId {
                                    lastId = UUID()
                                    clickFile(name: file.name, encoding: "UTF-8")
                                    showiCloud = false
                                } else {
                                    lastId = file.id
                                }
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            clickFile(name: file.name, encoding: "UTF-8")
                            showiCloud = false
                        }) {
                            Text("A").font(.caption)
                        }.buttonStyle(.borderedProminent)
                        Button(action: {
                            clickFile(name: file.name, encoding: "GB18030")
                            showiCloud = false
                        }) {
                            Text("简").font(.caption)
                        }.buttonStyle(.borderedProminent)
                        Button(action: {
                            clickFile(name: file.name, encoding: "BIG5-HKSCS")
                            showiCloud = false
                        }) {
                            Text("繁").font(.caption)
                        }.buttonStyle(.borderedProminent)
                        Button(action: {
                            clickFile(name: file.name, encoding: "Shift_JIS")
                            showiCloud = false
                        }) {
                            Text("あ").font(.caption)
                        }.buttonStyle(.borderedProminent)
                        Button(action: {
                            clickFile(name: file.name, encoding: "CP949")
                            showiCloud = false
                        }) {
                            Text("가").font(.caption)
                        }.buttonStyle(.borderedProminent)
                    }.opacity(file.id == lastId ? 1.0 : 0.0)
                }.listRowBackground(file.id == lastId ? Color.gray.opacity(0.2) : Color.clear)
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
        }.task {
            if let url = rootUrl() {
                pathUrl = url
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.refresh()
                }
            }
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
        return nil
    }

    func refresh() {
        files = []
        if let url = pathUrl {
            if url.lastPathComponent == "Documents" {
                // at root
            } else {
                files.append(File(
                    name: "..",
                    icon: "folder",
                    link: nil
                ))
            }
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                let folderNames = contents.filter( \.hasDirectoryPath ).map{ $0.lastPathComponent }.sorted()
                let sgfFiles = contents.filter{ $0.pathExtension.lowercased() == "sgf" }
                let sgfNames = sgfFiles.map{ $0.deletingPathExtension().lastPathComponent }.sorted()
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
        } else {
            files.append(File(
                name:"Please check the iCloud Drive sign in ...",
                icon: "exclamationmark.icloud",
                link: URL(string: UIApplication.openSettingsURLString)
            ))

            if let url = rootUrl() {
                pathUrl = url
            }
        }
    }

    func random() {
        if let url = pathUrl {
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
        if let url = pathUrl {
            if name == ".." {
                pathUrl = url.deletingLastPathComponent()
            } else {
                pathUrl = url.appendingPathComponent(name)
            }
        }
        refresh()
    }

    func clickFile(name: String, encoding: String) {
        if let url = pathUrl {
            match.sgfUrl = url.appendingPathComponent(name).appendingPathExtension("sgf")
            match.sgfEncoding = encoding
        }
    }
}

struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView(showiCloud: .constant(true))
            .environmentObject(Match())
    }
}
