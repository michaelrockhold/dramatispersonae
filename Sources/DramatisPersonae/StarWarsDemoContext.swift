/**
 * This defines a basic set of data for our Star Wars Schema.
 *
 * This data is hard coded for the sake of the demo, but you could imagine
 * fetching this data from a backend service rather than from hardcoded
 * values in a more complex demo.
 */
import StarWarsAPI

import SQLite

public final class StarWarsDemoContext: StarWarsContext {
    
    let db: Connection
    
    public init(dbfilepath: String) throws {
    
        db = try Connection(dbfilepath)
    }
    
    /**
     * Helper function to get a character by ID.
     */
    private func getCharacter(id: String) -> Character? {
        humanData[id] ?? droidData[id]
    }
    
    /**
     * Allows us to query for a Planet.
     */
    private func getPlanets(query: String) -> [Planet] {
        planetData
            .sorted(by: { $0.key < $1.key })
            .map({ $1 })
            .filter({ $0.name.lowercased().contains(query.lowercased()) })
    }
    
    /**
     * Allows us to query for a Human.
     */
    private func getHumans(query: String) -> [Human] {
        humanData
            .sorted(by: { $0.key < $1.key })
            .map({ $1 })
            .filter({ $0.name.lowercased().contains(query.lowercased()) })
    }
    
    /**
     * Allows us to query for a Droid.
     */
    private func getDroids(query: String) -> [Droid] {
        droidData
            .sorted(by: { $0.key < $1.key })
            .map({ $1 })
            .filter({ $0.name.lowercased().contains(query.lowercased()) })
    }

    // MARK: -
    
    /**
     * Allows us to query for a character"s friends.
     */
    public func getFriends(of character: Character) -> [Character] {
        character.friends.compactMap { id in
            getCharacter(id: id)
        }
    }
    
    /**
     * Allows us to fetch the undisputed hero of the Star Wars trilogy, R2-D2.
     */
    public func getHero(of episode: Episode?) -> Character {
        if episode == .empire {
            // Luke is the hero of Episode V.
            return luke
        }
        // R2-D2 is the hero otherwise.
        return r2d2
    }
    
    /**
     * Allows us to query for the human with the given id.
     */
    public func getHuman(id: String) -> Human? {
        humanData[id]
    }
    
    /**
     * Allows us to query for the droid with the given id.
     */
    public func getDroid(id: String) -> Droid? {
        droidData[id]
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
     * Allows us to query for either a Human, Droid, or Planet.
     */
    public func search(query: String) -> [SearchResult] {
        return getPlanets(query: query) + getHumans(query: query) + getDroids(query: query)
    }
}
