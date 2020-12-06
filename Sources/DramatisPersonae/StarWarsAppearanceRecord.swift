//
//  StarWarsAppearanceRecord.swift
//  DramatisPersonae
//
//  Created by Michael Rockhold on 12/6/20.
//

import SQLite
import StarWarsAPI

struct AppearanceRecord: Record {
    let characterID: CharacterID
    static let characterIDExpression = Expression<CharacterID>("characterID")
    let episodeID: String
    static let episodeIDExpression = Expression<String>("episodeID")
    
    static func createTable(builder: TableBuilder) {
        builder.column(characterIDExpression)
        builder.column(episodeIDExpression)
    }
    
    func insert(table: Table) -> Insert {
        return table.insert(AppearanceRecord.characterIDExpression <- characterID,
                            AppearanceRecord.episodeIDExpression <- episodeID)
    }
}
