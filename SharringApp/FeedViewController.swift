import UIKit
import FirebaseFirestore
import SDWebImage
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.commentText.text = postArray[indexPath.row].comment
        let index = postArray[indexPath.row].email.firstIndex(of: "@") ?? postArray[indexPath.row].email.endIndex
        let userName = postArray[indexPath.row].email[..<index]
        cell.emailText.text = String(userName)
        cell.postImage.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageurl))
        return cell
    }
    @IBOutlet weak var tableView: UITableView!
    var postArray = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        firebaseGetData()
    }
    func firebaseGetData(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "date", descending:true ).addSnapshotListener { snapshot, error in
            if error != nil {
                print("error")
            }else{
                self.postArray.removeAll(keepingCapacity: false)
                if snapshot?.isEmpty != true , snapshot != nil {
                    for document in snapshot!.documents{
                        if let email = document.get("email") as? String{
                            if let comment = document.get("comment") as? String{
                                if let imageurl = document.get("imageurl") as? String{
                                    let post = Post(email: email, comment: comment, imageurl: imageurl)
                                    self.postArray.append(post)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
