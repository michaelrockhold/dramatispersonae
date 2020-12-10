//
//  EpisodeRecord.swift
//  StarWarsDB
//
//  Created by Michael Rockhold on 12/6/20.
//

import SQLite
import StarWarsAPI

struct EpisodeRecord: Record {
    let name: String
    static let nameExpression = Expression<String>("name")
    let episodeID: String
    static let episodeIDExpression = Expression<String>("episodeID")
    
    static func createTable(builder: TableBuilder) {
        builder.column(episodeIDExpression, primaryKey: true)
        builder.column(nameExpression, unique: true)
    }
    
    func insert(table: Table) -> Insert {
        return table.insert(EpisodeRecord.episodeIDExpression <- episodeID, EpisodeRecord.nameExpression <- name)
    }
}
