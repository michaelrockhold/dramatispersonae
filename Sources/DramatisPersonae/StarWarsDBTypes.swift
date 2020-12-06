//
//  StarWarsDBTypes.swift
//  DramatisPersonae
//
//  Created by Michael Rockhold on 12/6/20.
//

import Foundation
import SQLite
import StarWarsAPI

enum Species: Int64, Value {
    
    case Human
    case Droid
    case Wookie
    
    static var declaredDatatype: String = "Species"
    typealias Datatype = Int64
    var datatypeValue: Int64 { return self.rawValue }
    
    static func fromDatatypeValue(_ datatypeValue: Int64) -> Self {
        return Self(rawValue: datatypeValue)!
    }
}

struct PlanetID: Value {
    typealias Datatype = Int64
    var datatypeValue: Int64
    static var declaredDatatype: String = "INTEGER"
    static func fromDatatypeValue(_ datatypeValue: Int64) -> Self { return Self(datatypeValue: datatypeValue) }
}

struct CharacterID: Value {
    typealias Datatype = Int64
    var datatypeValue: Int64
    static var declaredDatatype: String = "INTEGER"
    static func fromDatatypeValue(_ datatypeValue: Int64) -> CharacterID { return Self(datatypeValue: datatypeValue) }
}
