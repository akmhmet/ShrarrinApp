import UIKit
import FirebaseAuth
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toFirstVC", sender: nil)
        }catch{
            print("error")
        }
    }
}
