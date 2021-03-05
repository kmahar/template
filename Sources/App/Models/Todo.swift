{{#fluent}}import Fluent
{{/fluent}}{{#mongoDB}}import MongoDBVapor
{{/mongoDB}}
import Vapor

{{#fluent}}
final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}{{/fluent}}{{#mongoDB}}
struct Todo: Content {
    let _id: BSONObjectID?

    let title: String
}

extension Request {
    var todoCollection: MongoCollection<Todo> {
        self.mongoDB.client("app").collection("todos", withType: Todo.self)
    }
}
{{/mongoDB}}
