//
//  ItemsTableViewController.swift
//  GoMarket
//
//  Created by obss on 17.10.2022.
//

import UIKit

class ItemsTableViewController: UITableViewController {

//MARK:VARS
    
    var category: Category!
    var itemArray: [Item] = []
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.title = category?.name
        
        print("We have selected",category?.name)
        print("we have selected",category?.id)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            //downloadItems
            loadItems()
        }
    }

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])

        // Configure the cell...

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemToAddItem" {
            let vc = segue.destination as! ItemAddViewController
            vc.category = category!
        }
    }
    
    private func loadItems () {
   //MARK: PROBLEM
        downloadItemsFromFirebase(withCategoryId: category!.id!) { (allItems) in
            print ("We have \(allItems.count) items for this category!")
            self.itemArray = allItems
            self.tableView.reloadData()
            
        }
    }
    


}
