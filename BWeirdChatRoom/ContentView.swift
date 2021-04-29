//
//  ContentView.swift
//  BWeirdChatRoom
//
//  Created by seta cheam on 4/29/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var feelText: String = "";
    @State var moodObjects : [MoodObj] = [];
    @State var submitButtonText:String =  "";
    @State var selectedImage : String = "";
    
    var body: some View {
       
        ZStack {
            

        
            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.white]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
        AddMoodView(feelText : $feelText,
                    moodObjects: $moodObjects,
                    submitButtonText:$submitButtonText,
                    selectedImage: $selectedImage).onEnterText {

            if self.submitButtonText == "SUBMIT" {

                if self.moodObjects.count == 0 {
                    return;
                }

 
                self.moodObjects = [];
                self.feelText = ""

            }else{

                if feelText == "" {
                    return
                }

                let mood = MoodObj(type: "text", value: self.feelText, valueImage:nil)
                self.moodObjects.append(mood);

                self.feelText = ""
            }


        }.onEnterImage {
            let mood = MoodObj(type: "image", value: self.feelText, valueImage:self.selectedImage)
            self.moodObjects.append(mood);
        }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
