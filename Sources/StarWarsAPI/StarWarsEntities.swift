//
//  StarWarsAPI.swift
//  sqliteplayground
//
//  Created by Michael Rockhold on 11/23/20.
//

public typealias CharacterID = Int64
public typealias PlanetID = Int64

public enum Episode : String, Codable, CaseIterable {
    case newHope = "NEWHOPE"
    case empire = "EMPIRE"
    case jedi = "JEDI"
}

public protocol SearchResult : Codable {}

public protocol Character : SearchResult {
    var id: CharacterID { get }
    var name: String { get }
    var friends: [CharacterID] { get }
    var appearsIn: [Episode] { get }
}

public struct Planet : SearchResult, Codable {
    public let id: PlanetID
    public let name: String
    public let diameter: Int
    public let rotationPeriod: Int
    public let orbitalPeriod: Int
    public var residents: [String]
    
    public init(id: PlanetID, name: String, diameter: Int, rotationPeriod: Int, orbitalPeriod: Int, residents: [String] = [String]()) {
        self.id = id
        self.name = name
        self.diameter = diameter
        self.rotationPeriod = rotationPeriod
        self.orbitalPeriod = orbitalPeriod
        self.residents = residents
    }
}

public struct Human : Character, Codable {
    public let id: CharacterID
    public let name: String
    public let friends: [CharacterID]
    public let appearsIn: [Episode]
    public let homePlanet: String
    
    public init(id: CharacterID, name: String, friends: [CharacterID], appearsIn: [Episode], homePlanet: String) {
        self.id = id
        self.name = name
        self.friends = friends
        self.appearsIn = appearsIn
        self.homePlanet = homePlanet
    }
}

public struct Droid : Character, Codable {
    public let id: CharacterID
    public let name: String
    public let friends: [CharacterID]
    public let appearsIn: [Episode]
    public let primaryFunction: String
    
    public init(id: CharacterID, name: String, friends: [CharacterID], appearsIn: [Episode], primaryFunction: String) {
        self.id = id
        self.name = name
        self.friends = friends
        self.appearsIn = appearsIn
        self.primaryFunction = primaryFunction
    }
}

