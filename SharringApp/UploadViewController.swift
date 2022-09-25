import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageSelect))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @IBAction func uploadButtonTapped(_ sender: Any) {
        let image = UIImage(named: "SelectImage.png")
        if imageView.image == image{
           errorMessage(title: "Error", message: "Select Image")
        }else{
            let storage = Storage.storage()
            let storageReferance = storage.reference()
            let mediaFolder = storageReferance.child("media")
            if let data = imageView.image?.jpegData(compressionQuality: 0.5){
                let uuid = UUID().uuidString
                let imageReferance = mediaFolder.child("\(uuid).jpg")
                imageReferance.putData(data, metadata: nil) { (storagemedata, error)in
                    if error != nil {
                        self.connectionError(localizedDescription: error?.localizedDescription ?? "Try Again")
                    }else{
                        imageReferance.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                if let imageUrl = imageUrl {
                                    let firestoreDatabase = Firestore.firestore()
                                    let firestorePost = ["imageurl" : imageUrl, "comment" : self.commentTextField.text, "email" : Auth.auth().currentUser?.email, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                    firestoreDatabase.collection("Post").addDocument(data: firestorePost){ (error) in
                                        if error != nil {
                                            self.connectionError(localizedDescription: error?.localizedDescription ?? "TRY Again")
                                        }else{
                                            self.errorMessage(title: "Successful", message: "Your post has been uploaded ")
                                            self.clear()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func imageSelect(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    func errorMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    func connectionError(localizedDescription: String){
        self.errorMessage(title: "Error", message: localizedDescription )
    }
    @IBAction func clearButtonTapped(_ sender: Any) {
        clear()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func clear(){
        self.commentTextField.text = ""
        self.imageView.image = UIImage(named: "SelectImage.png")
    }
}
