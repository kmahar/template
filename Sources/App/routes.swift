{{#fluent}}import Fluent
{{/fluent}}{{mongoDB}}import MongoDBVapor
{{/mongoDB}}import Vapor

func routes(_ app: Application) throws {
    {{#leaf}}app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }{{/leaf}}{{^leaf}}app.get { req in
        return "It works!"
    }{{/leaf}}

    app.get("hello") { req -> String in
        return "Hello, world!"
    }{{#fluent}}

    try app.register(collection: TodoController()){{/fluent}}{{#mongoDB}}
    app.get("todos") { req -> EventLoopFuture<[Todo]> in
        req.todoCollection.find().flatMap { cursor in
            cursor.toArray()
        }
    }
    
    app.post("todos") { req -> EventLoopFuture<Response> in
        let todo = try req.content.decode(Todo.self)
        return req.todoCollection.insertOne(todo)
            .map { _ in Response(status: .created) }
    }{{/mongoDB}}
}
