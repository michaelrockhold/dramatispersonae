//
//  main.swift
//  sqliteplayground
//
//  Created by Michael Rockhold on 10/31/20.
//

import SQLite
import StarWarsAPI

struct StarWarsDB {
    
    // MARK: Tables
    fileprivate let characters: ConnectedTable<CharacterRecord>
    fileprivate let episodes: ConnectedTable<EpisodeRecord>
    fileprivate let appearances: ConnectedTable<AppearanceRecord>
    fileprivate let friends: ConnectedTable<FriendRecord>
    fileprivate let planets: ConnectedTable<PlanetRecord>
    
    // MARK: the Database Connection
    fileprivate let connection: Connection
    
    init(connectionPath: String? = nil) throws {
        if let cp = connectionPath {
            connection = try Connection(cp)
        } else {
            connection = try Connection(.temporary)
        }
        
        episodes = try ConnectedTable<EpisodeRecord>(connection: connection, name: "episodes")
        planets = try ConnectedTable<PlanetRecord>(connection: connection, name: "planets")
        characters = try ConnectedTable<CharacterRecord>(connection: connection, name: "characters")
        appearances = try ConnectedTable<AppearanceRecord>(connection: connection, name: "appearances")
        friends = try ConnectedTable<FriendRecord>(connection: connection, name: "friends")
    }
}

extension StarWarsDB {
    
    func populateTables() throws {
        
        _ = try episodes.insert(info: EpisodeRecord(name: "A New Hope", episodeID: Episode.newHope.rawValue))
        _ = try episodes.insert(info: EpisodeRecord(name: "The Empire Strikes Back", episodeID: Episode.empire.rawValue))
        _ = try episodes.insert(info: EpisodeRecord(name: "The Return of the Jedi", episodeID: Episode.jedi.rawValue))
        
        let tatooine = PlanetID(datatypeValue: try planets.insert(info: PlanetRecord(name: "Tatooine",
                                                                                     diameter: 10465,
                                                                                     rotationPeriod: 23,
                                                                                     orbitalPeriod: 304)))
        let alderaan = PlanetID(datatypeValue: try planets.insert(info: PlanetRecord(name: "Alderaan",
                                                                                     diameter: 12500,
                                                                                     rotationPeriod: 24,
                                                                                     orbitalPeriod: 364)))
        
        let luke = CharacterID(datatypeValue: try characters.insert(info: CharacterRecord(name: "Luke Skywalker", homePlanetID: tatooine)))
        let vader = CharacterID(datatypeValue: try characters.insert(info: CharacterRecord(name: "Darth Vader", homePlanetID: tatooine)))
        let han = CharacterID(datatypeValue: try characters.insert(info: CharacterRecord(name: "Han Solo", homePlanetID: alderaan)))
        
        let leia = CharacterID(datatypeValue: try characters.insert(info: CharacterRecord(name: "Leia Organa", homePlanetID: alderaan)))
        let tarkin = CharacterID(datatypeValue: try characters.insert(info: CharacterRecord(name: "Wilhuff Tarkin", homePlanetID: alderaan)))
        
        let c_3po = CharacterID(datatypeValue: try characters.insert(info: CharacterRecord(name: "C-3PO", primaryFunction: "Protocol")))
        let r2_d2 = CharacterID(datatypeValue: try characters.insert(info: CharacterRecord(name: "R2-D2", primaryFunction: "Astromech")))
        
        for appearance:(CharacterID,Episode) in [
            (c_3po, .newHope),
            (c_3po, .empire),
            (c_3po, .jedi),
            
            (r2_d2, .newHope),
            (r2_d2, .empire),
            (r2_d2, .jedi),
            
            (luke, .newHope),
            (luke, .empire),
            (luke, .jedi),
            
            (vader, .newHope),
            (vader, .empire),
            (vader, .jedi),
            
            (han, .newHope),
            (han, .empire),
            (han, .jedi),
            
            (leia, .newHope),
            (leia, .empire),
            (leia, .jedi),
            
            (tarkin, .newHope),
        ] {
            _ = try appearances.insert(info: AppearanceRecord(characterID: appearance.0, episodeID: appearance.1.rawValue))
        }
        
        for friendship:(CharacterID, CharacterID) in [
            (c_3po, luke),
            (c_3po, han),
            (c_3po, leia),
            (c_3po, r2_d2),
            
            (r2_d2, luke),
            (r2_d2, han),
            (r2_d2, leia),
            
            (luke, c_3po),
            (luke, han),
            (luke, leia),
            (luke, r2_d2),
            
            (vader, tarkin),
            
            (han, luke),
            (han, leia),
            (han, r2_d2),
            
            (leia, c_3po),
            (leia, han),
            (leia, luke),
            (leia, r2_d2),
            
            (tarkin, luke)
        ] {
            _ = try friends.insert(info: FriendRecord(characterID: friendship.0, friendID: friendship.1))
        }
    }
}

extension Planet {
    
    init(db: StarWarsDB, planetRecord: PlanetRecord) {
        var residentNames = [String]()
        do {
            for row in (try db.connection.prepare(db.characters.table.select(CharacterRecord.nameExpression).where(CharacterRecord.homePlanetIDExpression == planetRecord.planetID))) {
                
                residentNames.append(row[CharacterRecord.nameExpression])
            }
        }
        catch {}
        self.init(id: planetRecord.planetID.datatypeValue,
                  name: planetRecord.name,
                  diameter: planetRecord.diameter,
                  rotationPeriod: planetRecord.rotationPeriod,
                  orbitalPeriod: planetRecord.orbitalPeriod,
                  residents: residentNames)
    }
    
}

extension StarWarsDB : StarWarsContext {
    
    private func getFriendRecords(forCharacterID cid: CharacterID) -> [FriendRecord] {
        do {
            let fcharIDX = self.friends.table[FriendRecord.characterIDExpression]
            let friendIDX = friends.table[FriendRecord.friendIDExpression]
            let ccharIDX = self.characters.table[CharacterRecord.characterIDExpression]
            
            return (try connection.prepare(friends.table.where(fcharIDX == cid).join(characters.table, on: ccharIDX == friendIDX)))
                .compactMap { friendrow in
                    
                    return FriendRecord(table: friends.table, row: friendrow)
                }
        }
        catch {
            return [FriendRecord]()
        }
    }
    
    private func getEpisodes(for characterRecord: CharacterRecord) -> [Episode] {
        do {
            return (try connection.prepare(appearances.table.join(episodes.table,
                                                                  on: episodes.table[EpisodeRecord.episodeIDExpression] == appearances.table[AppearanceRecord.episodeIDExpression])
                                            .where(appearances.table[AppearanceRecord.characterIDExpression] == characterRecord.characterID)))
                .compactMap { episodeRecord in
                    
                    return Episode(rawValue: episodeRecord[episodes.table[EpisodeRecord.episodeIDExpression]])!
                }
        }
        catch {
            return [Episode]()
        }
    }
    
    public func getCharacters(query: QueryType) -> [Character] {
        do {
            return (try connection.prepare(query)).compactMap { row in
                
                let ci = CharacterRecord(row: row)!
                
                do {
                    return ci.constructCharacter(planetRecord: PlanetRecord(row: try connection.pluck(planets.table
                                                                                                        .where(PlanetRecord.planetIDExpression == ci.homePlanetID))),
                                                 friends: getFriendRecords(forCharacterID: ci.characterID),
                                                 episodes: getEpisodes(for: ci))
                }
                catch {
                    return nil
                }
                
            }
        } catch {
            return [Character]()
        }
    }
    
    public func getCharacter(characterID: CharacterID) -> Character? {
        let found = getCharacters(query: characters.table.select(characters.table[*]).where(CharacterRecord.characterIDExpression == characterID))
        return found.count < 1 ? nil : found[0]
    }
    
    func getHuman(id: Int64) -> Human? {
        let characterID = CharacterID(datatypeValue: id)
        guard let character = getCharacter(characterID: characterID) else {
            return nil
        }
        return character as? Human
    }
    
    func getDroid(id: Int64) -> Droid? {
        let characterID = CharacterID(datatypeValue: id)
        guard let character = getCharacter(characterID: characterID) else {
            return nil
        }
        return character as? Droid
    }
    
    public func getCharacters(like s: String) -> [SearchResult] {
        return getCharacters(query: characters.table.filter(CharacterRecord.nameExpression.like(s)))
    }
    
    public func getPlanets(like s: String) -> [SearchResult] {
        do {
            return (try connection.prepare(planets.table.filter(PlanetRecord.nameExpression.like(s))))
                .compactMap { row in
                    return Planet(db: self, planetRecord: PlanetRecord(row: row)!)
                }
        }
        catch {
            return [Planet]()
        }
    }
    
    /**
     * Allows us to get the secret backstory, or not.
     */
    public func getSecretBackStory() throws -> String? {
        struct Secret : Error, CustomStringConvertible {
            let description: String
        }
        throw Secret(description: "secretBackstory is secret.")
    }
    
    /**
     * Allows us to query for a character"s friends.
     */
    public func getFriends(of character: Character) -> [Character] {
        return character.friends.compactMap { characterID in getCharacter(characterID: CharacterID(datatypeValue: characterID)) }
    }
    
    /**
     * Allows us to fetch the undisputed hero of the Star Wars trilogy, R2-D2.
     */
    public func getHero(of episode: Episode) -> Character {
        if episode == .empire {
            // Luke is the hero of Episode V.
            return getCharacters(like: "Luke Skywalker")[0] as! Character
        }
        // R2-D2 is the hero otherwise.
        return getCharacters(like: "R2-D2")[0] as! Character
    }
    
    public func searchCharacterID(characterName: String, characterSpecies: Species) -> CharacterID? {
        guard let info = try? connection.pluck(characters.table.where(CharacterRecord.nameExpression == characterName && CharacterRecord.speciesExpression == characterSpecies)) else {
            return nil
        }
        return info[CharacterRecord.characterIDExpression]
    }
    
    /**
     * Allows us to query for either a Human, Droid, or Planet.
     */
    public func search(query s: String) -> [SearchResult] {
        return getPlanets(like: s) + getCharacters(like: s)
    }
}
