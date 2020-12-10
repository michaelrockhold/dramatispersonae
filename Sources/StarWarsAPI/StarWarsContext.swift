/**
 * This defines a basic set of data for our Star Wars Schema.
 *
 * This data is hard coded for the sake of the demo, but you could imagine
 * fetching this data from a backend service rather than from hardcoded
 * values in a more complex demo.
 */
public protocol StarWarsContext {
    
    /**
     * Allows us to query for a character"s friends.
     */
    func getFriends(of character: Character) -> [Character]
    
    /**
     * Allows us to fetch the undisputed hero of the Star Wars trilogy, R2-D2.
     */
    func getHero(of episode: Episode) -> Character
    
    /**
     * Allows us to query for the human with the given id.
     */
    func getHuman(id: Int) -> Human?
    
    /**
     * Allows us to query for the droid with the given id.
     */
    func getDroid(id: Int) -> Droid?
    
    /**
     * Allows us to get the secret backstory, or not.
     */
    func getSecretBackStory() throws -> String?
            
    /**
     * Allows us to query for either a Human, Droid, or Planet.
     */
    func search(query: String) -> [SearchResult]
}
