//
//  StarWarsDBRows.swift
//  DramatisPersonae
//
//  Created by Michael Rockhold on 12/6/20.
//

import Foundation
import SQLite
import StarWarsAPI

protocol Record {
    static func createTable(builder: TableBuilder)
    
    func insert(table: Table) -> Insert
}

struct ConnectedTable<T: Record> {
    let table: Table
    let connection: Connection
    
    init(connection c: Connection, name: String) throws {
        table = Table(name)
        connection = c
        try connection.run(table.create(ifNotExists: true) { t in
            T.createTable(builder: t)
        })
    }
    
    func insert(info: T) throws -> Int64 {
        return try connection.run(info.insert(table: table))
    }
}
