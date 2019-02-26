//
//  WaterType.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

// Tournment Creation Titles
enum TournamentSetup: String {
    case Basic = "Basic Details"
    case Dates = "Run Dates"
    case Fish = "Fish Species"
    case Divisions = "Divisions"
    case Awards = "Awards"
    case Summary = "Tournament Summary"
}

// Water Types
enum Water: String {
    case Fresh = "Freshwater"
    case Salt = "Saltwater"
}

// Participant types
enum Participants: String {
    case Angler = "Angler"
    case Boat = "Boat"
    case Captain = "Captain"
}

// Official Measurments
enum Metrics: String {
    case Weight = "Weight"
    case Length = "Length"
}


// TODO: Tab icons
