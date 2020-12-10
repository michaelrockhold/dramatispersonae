//
//  CharacterRecord.swift
//  StarWarsDB
//
//  Created by Michael Rockhold on 12/6/20.
//

import SQLite
import StarWarsAPI

struct CharacterRecord: Record {
    let characterID: CharacterID
    static let characterIDExpression = Expression<CharacterID>("characterID")
    
    let name: String
    static let nameExpression = Expression<String>("name")
    
    let species: Species
    static let speciesExpression = Expression<Species>("species")
    
    let homePlanetID: PlanetID
    static let homePlanetIDExpression = Expression<PlanetID>("homePlanetID")
    
    let primaryFunction: String
    static let primaryFunctionExpression = Expression<String>("primaryFunction")
    
    init(name n: String, species s: Species, homePlanetID pID: PlanetID = PlanetID(datatypeValue: -1), primaryFunction pf: String = "") {
        characterID = CharacterID(datatypeValue: -1)
        name = n
        species = s
        homePlanetID = pID
        primaryFunction = pf
    }
    
    init(name n: String, homePlanetID pID: PlanetID) {
        self.init(name: n, species: .Human, homePlanetID: pID)
    }
    
    init(name n: String, primaryFunction pf: String) {
        self.init(name: n, species: .Droid, primaryFunction: pf)
    }
    
    init?(row r: Row?) {
        guard let row = r else {
            return nil
        }
        characterID = CharacterID(datatypeValue: row[CharacterRecord.characterIDExpression].datatypeValue)
        name = row[CharacterRecord.nameExpression].datatypeValue
        species = Species(rawValue: row[CharacterRecord.speciesExpression].datatypeValue)!
        homePlanetID = PlanetID(datatypeValue: row[CharacterRecord.homePlanetIDExpression].datatypeValue)
        primaryFunction = row[CharacterRecord.primaryFunctionExpression].datatypeValue
    }
    
    static func createTable(builder: TableBuilder) {
        builder.column(characterIDExpression, primaryKey: true)
        builder.column(nameExpression, unique: true)
        builder.column(speciesExpression)
        builder.column(homePlanetIDExpression, defaultValue:PlanetRecord.unknownPlanet)      // only for non-droids
        builder.column(primaryFunctionExpression, defaultValue: "")   // only for droids
    }
    
    func insert(table: Table) -> Insert {
        return table.insert(CharacterRecord.nameExpression <- name,
                            CharacterRecord.speciesExpression <- species,
                            CharacterRecord.homePlanetIDExpression <- homePlanetID,
                            CharacterRecord.primaryFunctionExpression <- primaryFunction)
    }
}
