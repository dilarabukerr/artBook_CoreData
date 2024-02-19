//
//  DetailsVC.swift
//  artBook_CoreData
//
//  Created by Dilara Büker on 19.02.2024.
//

import UIKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer) //klavye ve textfield hariç nereye tıklarsan tıkla klavye kapanacak

    }
    
    @objc func hideKeyboard() {
        view.endEditing(true) //keyboard kapatmak için
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        print ("test")
    }
    
}
