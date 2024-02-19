//  ViewController.swift
//  artBook_CoreData
//
//  Created by Dilara Büker on 19.02.2024.

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //navigasyon kontrolü --> navigasyon barda sağ üste bir buton ekleyeceğiz..
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    // UIBarButtenItem --> buton için hazır itemler sağlıyor
        
    }
    
    @objc func addButtonClicked() {
        performSegue(withIdentifier:"toDetailsCV", sender: nil)
    }
}

