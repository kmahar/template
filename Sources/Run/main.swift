import App
{{#mongoDB}}import MongoDBVapor
{{/mongoDB}}import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer {
    {{#mongoDB}}app.mongoDB.cleanup()
    cleanupMongoSwift()
    {{/mongoDB}}app.shutdown()
}
try configure(app)
try app.run()
