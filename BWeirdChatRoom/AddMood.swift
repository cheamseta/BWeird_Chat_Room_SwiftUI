//
//  AddMood.swift
//  Mood Diary
//
//  Created by seta cheam on 4/26/21.
//

import SwiftUI

struct AddMoodView : View {
    
    @Binding var feelText: String
    @Binding var moodObjects : [MoodObj]
    @Binding var submitButtonText:String;
    @Binding var selectedImage : String;
    
    @State var isShowPhotoLibarary = false;
    @State var animationAmount : Double = 0;
    let screenWidth = UIScreen.main.bounds.size.width
    
    var enterTextAction: (() -> Void)?
    var enterImageAction: (() -> Void)?
    
    @State var isHideBigStatus : Bool = false;
    
    var body: some View {
        
        VStack {
            
            if isHideBigStatus == false || moodObjects.count == 0 {
                Text("What is\non your mind ?" )
                    .frame(width: screenWidth - 20)
                    .font(Font.system(size: 50))
                    .foregroundColor(.white)
                    .opacity(Double(self.animationAmount))
                    .animation(Animation.easeInOut(duration: 2))
                    .onAppear {
                        self.animationAmount = 1
                    }
            }
            
            
            ReverseScrollView {
                VStack(alignment: .leading,spacing: 15) {
                    ForEach(moodObjects) { moodObj in
                        
                        if moodObj.type == "text" {
                            Text(moodObj.value)
                                .foregroundColor(.black)
                                .font(Font.custom( "", size: 15))
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(15)
                                .frame(width: screenWidth - 20, alignment: .leading)
                                .padding(.leading, 10)
                        }else{
                            
                            
                            Image(uiImage: UIImage(contentsOfFile: moodObj.valueImage!) ?? UIImage())
                                .resizable()
                                .cornerRadius(15)
                                .padding(15)
                                .background(Color.white)
                                .cornerRadius(15)
                                .frame(width: 300, height:300, alignment: .leading)
                                .padding(.leading, 10)
                            
                        }
                        
                        
                        
                    }
                }.padding(.bottom, 10)
            }
            
     
            
            TextField("Write on your mind here....", text: $feelText)
                .foregroundColor(.black)
                .font(Font.system(size: 20))
                .frame(width: screenWidth - 20, height: 40, alignment: .top)
                .padding(10)
                .onTapGesture {
                    self.isHideBigStatus = true;
                }
                .onChange(of: feelText, perform: { value in
                    if feelText.count > 0 {
                        self.submitButtonText = "ENTER"
                    }else{
                        self.submitButtonText = "SUBMIT"
                    }
                })
            
            
            HStack{
                
          
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.isShowPhotoLibarary = true;
                
                }) {
                    Image("Image")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                    
                }
                .sheet(isPresented: $isShowPhotoLibarary, onDismiss: self.enterImageAction!, content: {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                })
                
                Spacer()
                
                Button(action:self.enterTextAction!) {
                    Text(self.submitButtonText)
                        .font(Font.system(size: 15))
                        .foregroundColor(.black)
                        .padding(.trailing,20)
                        .padding(.bottom, 10)
                }
                
            }
            
        }
        
    }
}

extension AddMoodView {
    
    func onEnterText(_ action:  @escaping () -> Void ) -> Self {
        var copy = self
        copy.enterTextAction = action
        return copy
    }
    
    func onEnterImage(_ action:  @escaping () -> Void ) -> Self {
        var copy = self
        copy.enterImageAction = action
        return copy
    }
    
}


// Thank for reverse scrollview tutorial from Khanh Nguyen channel
// Please check out from him https://www.youtube.com/watch?v=_6N7RDCetSo

struct ReverseScrollView<Content: View> : View {
    @State private var contentHeight: CGFloat = CGFloat.zero
    @State private var scrollOffset: CGFloat = CGFloat.zero
    @State private var currentOffset: CGFloat = CGFloat.zero
    
    var content : Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body : some View {
        GeometryReader { outReader in
            VStack {
                self.content
                    .background(
                        GeometryReader { inReader in
                            Color.clear.preference(key: ViewHeightKey.self, value: inReader.size.height)
                        })
            }
            .onPreferenceChange(ViewHeightKey.self) {
                self.updateContentHeight(with: $0, outHeight: outReader.size.height)
            }
            .frame(height: outReader.size.height, alignment: .bottom)
            .offset(y: self.currentOffset + self.scrollOffset)
            .animation(.easeInOut)
            .gesture( DragGesture()
                        .onChanged({ self.onDragChanged($0) })
                        .onEnded({ self.onDragEnded($0, outHeight: outReader.size.height)})
            )
            
        }
    }
    
    func onDragChanged(_ value: DragGesture.Value) {
        self.scrollOffset = value.translation.height
    }
    
    func onDragEnded(_ value: DragGesture.Value, outHeight: CGFloat) {
        let scrollOffset = value.translation.height
        updateOffset(with: scrollOffset, outHeight: outHeight)
        self.scrollOffset = 0
        
    }
    
    func updateContentHeight(with height: CGFloat, outHeight: CGFloat) {
        let topLimit = self.contentHeight - height
        self.currentOffset = outHeight - height
        self.contentHeight = height
        self.updateOffset(with: topLimit, outHeight: outHeight)
    }
    
    func updateOffset(with scrollOffset : CGFloat, outHeight: CGFloat) {
        let topLimit = self.contentHeight - outHeight
        
        if topLimit < .zero {
            self.currentOffset = .zero
        } else {
            var predictedOffset = currentOffset + scrollOffset
            if predictedOffset < .zero {
                predictedOffset = .zero
            } else if predictedOffset > topLimit {
                predictedOffset = topLimit
            }
            self.currentOffset = predictedOffset
        }
    }
}

struct ViewHeightKey : PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
