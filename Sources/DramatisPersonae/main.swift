import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import NIO

import Graphiti
import GraphQL

import StarWarsAPI

typealias In = APIGateway.V2.Request
typealias Out = APIGateway.V2.Response

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
    }

    guard let body: QueryBody = try? request.bodyObject() else {
        return callback(.failure(DramatisPersonaeError.BAD_REQUEST))
    }

    let api = StarWarsAPI()

    let graphql_context = StarWarsDemoContext()

    api.execute(
        request: body.query,
        context: graphql_context,
        on: context.eventLoop,
        variables: body.variables ?? [:]
        
    ).whenSuccess { graphql_result in
        // TODO: handle conditions other than complete success
        callback(.success(Out(with: graphql_result.data, statusCode: .ok)))
    }
}