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
    case DivisionDetails = "Division Details"
    case Awards = "Awards"
    case Summary = "Tournament Summary"
}

// Water Types
enum Water: String {
    case Fresh = "Freshwater"
    case Salt = "Saltwater"
    case Both = "Both"
}

// Participant types
enum Participants: String {
    case Participants = "Participants"
    case Angler = "Angler"
    case Boat = "Boat"
    case Captain = "Captain"
}

// Official Measurments
enum Metrics: String {
    case Weight = "Weight"
    case Length = "Length"
}

// Tab bar titles
enum TabTitles: String {
    case Dashboard = "Dashboard"
    case Profile = "Profile"
    case Weather = "Weather"
    case Map = "Map"
    case TrophyWall = "Trophy Wall"
    case Leaderboard = "Leaderboard"
}

// Seque Identifiers
enum Segues: String {
    case Basic = "toBasic"
    case Dates = "toRunDates"
    case Fish = "toFishSpecies"
    case Divisions = "toDivisions"
    case Summary = "toSummary"
    case Details = "toDivisionDetails"
    case Dashboard = "toDashboard"
    case AnglerProfile = "toAnglerProfile"
    case OrganizerProfile = "toOrganizerProfile"
    case Awards = "toAwards"
}

// TODO: Firebase


// TODO: Tab icons
