//
//  DetailsVC.swift
//  artBook_CoreData
//
//  Created by Dilara Büker on 19.02.2024.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer) //klavye ve textfield hariç nereye tıklarsan tıkla klavye kapanacak
    /* 
     Bu kod bir iOS uygulamasında bir UIImageView nesnesinin kullanıcı etkileşimine izin verilmesini sağlar.
     isUserInteractionEnabled özelliği, kullanıcı etkileşimlerini (örneğin, dokunma) etkinleştirip devre dışı bırakmanızı sağlar.
     Bu özelliği true olarak ayarlamak, UIImageView nesnesinin kullanıcı etkileşimlerini algılamasına ve buna yanıt vermesine izin verir.
     Bu genellikle bir görüntünün tıklanabilir olmasını sağlamak veya üzerine çeşitli etkileşimler eklemek için kullanılır.
     */
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)

    }
    @objc func hideKeyboard() {
        view.endEditing(true) //keyboard kapatmak için
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController() //viewcontrollerlar arasında geçiş için.
        picker.delegate = self
       /* UIImagePickerController, iOS SDK'daki bir sınıftır ve bir görüntü seçme arayüzü sağlar. 
        Kullanıcıların cihazlarındaki fotoğraf albümünden veya kamera aracılığıyla yeni bir fotoğraf veya video çekerek bir 
        medya seçmelerine olanak tanır.Bu sınıf, kullanıcıya belirli izinlerle birlikte kamera ve fotoğraf albümüne erişme yetkisi verir.

        Bu sınıf genellikle uygulamalarda profil resmi seçme, bir fotoğraf galerisi uygulaması oluşturma veya belirli bir işleve
        dayalı olarak resim seçme gibi durumlar için kullanılır. Kullanıcılar seçtikleri medyayı seçtikten sonra,
        uygulama bu medya ile ilgili işlemler yapabilir veya kullanıcıya başka bir seçenek sunabilir. */
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true //kullanıcı seçtiği görseli editleyebilir.
        present(picker, animated: true, completion: nil)
    }
    //medyayla işimiz bitince bu fonksiyon seçilen görseli döndürüyo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)//açtığımız pickerı kapatmak için.
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //appdelegate'ı değişken olarak tanımlıyoruz (zorunlu)
        let context = appDelegate.persistentContainer.viewContext //supporting fonksiyonları kullanabilmek için.
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context) //paintings entitymizin içine veri kaydetmek için
        
        newPainting.setValue(nameText.text!, forKey: "name")
        newPainting.setValue(artistText.text, forKey: "artist")
        
        if let year = Int(yearText.text!) {
            newPainting.setValue(year, forKey: "year")
        }
        
        newPainting.setValue(UUID(), forKey: "id") //bu kod parçası ile ID'ler için otomatik ID atanacak
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5) //görselleri veriye çevirdik.
        //0.5 ile görselin boyutunu küçülttük (opsiyonel)
        newPainting.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("success")
        } catch {
            print("Error!")
        }
        //kayıt olan gözlemciler için mesaj yollamaya yarar
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true) // save ettikten sonra bir önceki viewcontrollera geri gitmek için
        
        
    }
    
}


