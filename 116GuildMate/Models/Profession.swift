//
//  Profession.swift
//  116GuildMate
//

import Foundation

enum Profession: String, CaseIterable, Codable {
    case mining = "Mining"
    case herbalism = "Herbalism"
    case skinning = "Skinning"
    case blacksmithing = "Blacksmithing"
    case engineering = "Engineering"
    case alchemy = "Alchemy"
    case enchanting = "Enchanting"
    case tailoring = "Tailoring"
    case leatherworking = "Leatherworking"
    case jewelcrafting = "Jewelcrafting"
    case inscription = "Inscription"
    case cooking = "Cooking"
    case fishing = "Fishing"
    case archaeology = "Archaeology"

    var icon: String {
        switch self {
        case .mining: return "hammer.fill"
        case .herbalism: return "leaf.fill"
        case .skinning: return "scissors"
        case .blacksmithing: return "wrench.fill"
        case .engineering: return "gearshape.fill"
        case .alchemy: return "flask.fill"
        case .enchanting: return "wand.and.stars"
        case .tailoring: return "circle.circle"
        case .leatherworking: return "handbag.fill"
        case .jewelcrafting: return "diamond.fill"
        case .inscription: return "pencil"
        case .cooking: return "fork.knife"
        case .fishing: return "fish.fill"
        case .archaeology: return "map.fill"
        }
    }
}
