//
//  MoodModel.swift
//  BWeirdChatRoom
//
//  Created by seta cheam on 4/29/21.
//

import SwiftUI

struct Mood: Identifiable {
    let id = UUID()
    let emoji :String
    let mood : String
    let objects: [MoodObj]
}

struct MoodObj: Identifiable {
    let id = UUID()
    let type : String
    let value : String
    let valueImage : String?
}

