//
//  StarWarsFriendRecord.swift
//  DramatisPersonae
//
//  Created by Michael Rockhold on 12/6/20.
//

import SQLite
import StarWarsAPI

struct FriendRecord: Record {
    let characterID: CharacterID
    static let characterIDExpression = Expression<CharacterID>("characterID")
    let friendID: CharacterID
    static let friendIDExpression = Expression<CharacterID>("friendID")
    
    static func createTable(builder: TableBuilder) {
        builder.column(characterIDExpression)
        builder.column(friendIDExpression)
    }
    
    init(characterID cid: CharacterID, friendID fid: CharacterID) {
        characterID = cid
        friendID = fid
    }
    
    init?(table: Table, row r: Row?) {
        guard let row = r else {
            return nil
        }
        let charIDX = table[FriendRecord.characterIDExpression]
        let friendIDX = table[FriendRecord.friendIDExpression]
        self.init(characterID: CharacterID(datatypeValue: row[charIDX].datatypeValue),
                  friendID: CharacterID(datatypeValue: row[friendIDX].datatypeValue))
    }
    
    func insert(table: Table) -> Insert {
        return table.insert(FriendRecord.characterIDExpression <- characterID,
                            FriendRecord.friendIDExpression <- friendID)
    }
}
