//
//  ContentView.swift
//  Leftoverz
//
//  Created by Jasmine Parekh on 4/18/23.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}


struct TodoItem: Identifiable {
    let id: UUID
    var title: String
}


struct ContentView: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var item: String = ""
    @State var mvText: String = ""
    @State var items = [TodoItem(id: UUID(), title: "test1"), TodoItem(id: UUID(), title: "test2"), TodoItem(id: UUID(), title: "test3")]
    @ObservedObject var classifier: ImageClassifier
    
    var body: some View {
        VStack{
            VStack {
                NavigationView {
                    VStack {
                        List {
                            ForEach($items) { $ing in
                                TextField("Title", text: $ing.title)
                            }
                            .onDelete {
                                (indexSet) in
                                items.remove(atOffsets: indexSet)
                            }
                        }
                    }
                    .navigationTitle("Current Items")
                    .toolbar { EditButton() }
                }
                HStack {
                    TextField(" Manually Add Items", text:$mvText)
                        .padding(5)
//                        .frame(width: 350, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 4)
                        )
                        .padding()
                    Button(action: {
                        items.append(TodoItem(id: UUID(), title: mvText))
                    }) {
                        Image(systemName: "arrow.up")
//                        Image(systemName: "plus") // Figure which to use
                    }
                    .padding()
                }
                Spacer()
            }
            Spacer()
            HStack {
                Button(action: {
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }) {
                    Image(systemName: "camera")
                        .onTapGesture {
                            isPresenting = true
                            sourceType = .camera
                        }
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding()
                Button(action: {
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }) {
                    Image(systemName: "photo")
                        .onTapGesture {
                            isPresenting = true
                            sourceType = .photoLibrary
                        }
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding()
                Spacer()
                VStack {
                    Group {
                        if let imageClass = classifier.imageClass {
                            HStack{
                                Text("Image categories:")
                                    .font(.caption)
                                Text(imageClass)
                                    .bold()
                            }
                        } else {
                            HStack{
                                Text("Image categories: N/A")
                                    .font(.caption)
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding()
                }
                Spacer()
                Button(action: {
                    if let imageClass2 = classifier.imageClass {
                        items.append(TodoItem(id: UUID(), title: imageClass2))
                    }
                }) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
                .padding()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(classifier: ImageClassifier())
    }
}
