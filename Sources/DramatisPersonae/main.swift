import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import NIO

import Graphiti
import GraphQL

import StarWarsAPI
import StarWarsDB

typealias In = APIGateway.Request
typealias Out = APIGateway.Response

struct QueryBody: Codable {
    public let query: String
    public let variables: [String:GraphQL.Map]?
    
    public struct Field {
        static let query = "query"
        static let variables = "variables"
    }
}

//============================================
// We receive an APIGateway.V2.Request with a JSON body;
// we respond with an APIGateway.V2.Response containing a JSON body
Lambda.run { (context, request: In, callback: @escaping (Result<Out, Error>) -> Void) in
   
    enum DramatisPersonaeError: Error {
        case BAD_REQUEST
        case BAD_DB
    }

    guard let body: QueryBody = try? request.bodyObject() else {
        return callback(.failure(DramatisPersonaeError.BAD_REQUEST))
    }

    let swcontext: StarWarsContext
    do {
//        swcontext = try StarWarsDB(connectionPath: "/opt/swift/starwarsdb.sqlite3")
        swcontext = try StarWarsDB()
    }
    catch {
        return callback(.failure(DramatisPersonaeError.BAD_DB))
    }
    let api = StarWarsAPI(context: swcontext)

    api.execute(
        request: body.query,
        context: api.context,
        on: context.eventLoop,
        variables: body.variables ?? [:]
        
    ).whenSuccess { graphql_result in
        // TODO: handle conditions other than complete success
        callback(.success(Out(with: graphql_result.data, statusCode: .ok)))
    }
}


//let db = try StarWarsDB(connectionPath: "/Users/mr/Data/db.sqlite3")
////let db = try StarWarsDB()
//
////try db.populateTables()
//
//guard let lukeID = db.searchCharacterID(characterName: "Luke Skywalker", characterSpecies: .Human) else {
//    print("no such character")
//    exit(0)
//}
//
//let luke = db.getCharacter(characterID: lukeID)!
//print(luke)
//
//for f in db.getFriends(of: luke) {
//    print(f)
//}
//
//print(db.search(like: "%tatoo%"))
//print(db.search(like: "Tatooine"))
//print(db.search(like: "% skywalker"))
//print(db.search(like: "c-3po"))
