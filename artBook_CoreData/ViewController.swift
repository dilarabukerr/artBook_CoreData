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
    var selectedPainting = ""
    var selectedPaintingID : UUID?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    //coredata'dan verileri çekmek için fonksiyon oluşturuyoruz
    @objc func getData() {
        
        nameArray.removeAll(keepingCapacity: false) //arrayleri temizleyip coredatada bir kere görünüp dizide birden fazla görünmemesini sağlamadık
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate //appDelegate'i değişken olarak tanımlıyoruz (çağırabilmek için)
        let context = appDelegete.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings") //fetch ile dataları getir.
        fetchRequest.returnsObjectsAsFaults = false // Core Data'nın sorgudan dönen nesnelerin tam verilerini döndürmesini sağlar.
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    
                    self.tableView.reloadData()//tableviewı güncelliyoruz, yeni gelen datayı görmek için.
                }
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
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func addButtonClicked() {
        selectedPainting = ""//eğer artıya tıklandıysa görsel seçilecek
        performSegue(withIdentifier:"toDetailsCV", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //diğer tarafa aktaracağız.
        if segue.identifier == "toDetailsCV" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPainting = selectedPainting
            destinationVC.chosenPaintingID = selectedPaintingID //seçilen paintingin hem ismini hem idsini diğer tarafa aktarıyoruz.
        }
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //bir veriye tıklandığında segue
        selectedPainting = nameArray [indexPath.row] //eğer isme tıklandıysa görsel verileri gelecek.
        selectedPaintingID = idArray [indexPath.row]
        performSegue(withIdentifier: "toDetailsCV", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
                let idString = idArray[indexPath.row].uuidString
                fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            if let id = result.value(forKey: "id") as? UUID {
                               if id == idArray[indexPath.row] {
                                    context.delete(result)
                                    nameArray.remove(at: indexPath.row)
                                    idArray.remove(at: indexPath.row)
                                    self.tableView.reloadData()
                                    do {
                                        try context.save()
                                        
                                    } catch {
                                        print("error")
                                    }
                                    break
                                }
                            }
                        }           
                    }
                } catch {
                    print("error")
                }
            }
        }
}

