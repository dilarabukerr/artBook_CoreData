//  ViewController.swift
//  artBook_CoreData
//
//  Created by Dilara Büker on 19.02.2024.

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var idArray = [UUID]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    //coredata'dan verileri çekmek için fonksiyon oluşturuyoruz
    func getData() {
        
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate //appDelegate'i değişken olarak tanımlıyoruz (çağırabilmek için)
        let context = appDelegete.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings") //fetch ile dataları getir.
        fetchRequest.returnsObjectsAsFaults = false // Core Data'nın sorgudan dönen nesnelerin tam verilerini döndürmesini sağlar.
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                
                self.tableView.reloadData()//tableviewı güncelliyoruz, yeni gelen datayı görmek için.
            }
        } catch {
            print("Error!")
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    //navigasyon kontrolü --> navigasyon barda sağ üste bir buton ekleyeceğiz..
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    // UIBarButtenItem --> buton için hazır itemler sağlıyor
        
        getData()
   
    }
    
    @objc func addButtonClicked() {
        performSegue(withIdentifier:"toDetailsCV", sender: nil)
    }
}

