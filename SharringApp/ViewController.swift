import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailTextField.text != "" , passwordTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil {
                    self.connectionError(localizedDescription: error?.localizedDescription ?? "Try Again" )
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            blankError()
        }
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        if emailTextField.text != "" , passwordTextField.text != ""{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdataresult, error) in
                if error != nil {
                    self.connectionError(localizedDescription: error?.localizedDescription ?? "Try Again" )
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            blankError()
        }
    }
    func errorMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    func blankError(){
        errorMessage(title: "Error!", message: "E-mail and password cannot be left blank")
    }
    func connectionError(localizedDescription: String){
        self.errorMessage(title: "Error", message: localizedDescription )
    }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}

