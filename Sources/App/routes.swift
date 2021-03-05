{{#fluent}}import Fluent
{{/fluent}}import Vapor

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
        let todo = try req.decode(Todo.self)
    }
    {{/mongoDB}}
}
