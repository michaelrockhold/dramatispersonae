//
//  StarWarsPlanetRecord.swift
//  DramatisPersonae
//
//  Created by Michael Rockhold on 12/6/20.
//

import SQLite
import StarWarsAPI

struct PlanetRecord: Record {
    static let unknownPlanet = PlanetID(datatypeValue: -1)
    
    let planetID: PlanetID
    static let planetIDExpression = Expression<PlanetID>("planetID")
    let name: String
    static let nameExpression = Expression<String>("name")
    let diameter: Int
    static let diameterExpression = Expression<Int>("diameter")
    let rotationPeriod: Int
    static let rotationPeriodExpression = Expression<Int>("rotationPeriod")
    let orbitalPeriod: Int
    static let orbitalPeriodExpression = Expression<Int>("orbitalPeriod")
    
    init(name n: String, diameter d: Int, rotationPeriod rp: Int, orbitalPeriod op: Int) {
        planetID = PlanetRecord.unknownPlanet
        name = n
        diameter = d
        rotationPeriod = rp
        orbitalPeriod = op
    }
    
    init?(row r: Row?) {
        guard let row = r else {
            return nil
        }
        planetID = row[PlanetRecord.planetIDExpression]
        name = row[PlanetRecord.nameExpression]
        diameter = row[PlanetRecord.diameterExpression]
        rotationPeriod = row[PlanetRecord.rotationPeriodExpression]
        orbitalPeriod = row[PlanetRecord.orbitalPeriodExpression]
    }
    
    static func createTable(builder: TableBuilder) {
        builder.column(planetIDExpression, primaryKey: true)
        builder.column(nameExpression, unique: true)
        builder.column(diameterExpression)
        builder.column(rotationPeriodExpression)
        builder.column(orbitalPeriodExpression)
    }
    
    func insert(table: Table) -> Insert {
        return table.insert(PlanetRecord.nameExpression <- name,
                            PlanetRecord.diameterExpression <- diameter,
                            PlanetRecord.rotationPeriodExpression <- rotationPeriod,
                            PlanetRecord.orbitalPeriodExpression <- orbitalPeriod)
    }
}
