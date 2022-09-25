import Foundation
class Post {
    var email : String
    var comment : String
    var imageurl : String
    init (email: String, comment : String, imageurl : String){
        self.email = email
        self.comment = comment
        self.imageurl = imageurl
    }
}
