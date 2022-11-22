//
//  BasketViewController.swift
//  GoMarket
//
//  Created by obss on 22.11.2022.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {
    
//MARK: IBOUTLETS
    
    @IBOutlet weak var itemsInBasketLabel: UILabel!
    @IBOutlet weak var checkOutOutlet: UIButton!
    @IBOutlet weak var itemTotalLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
    //MARK: VARS
    
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    
    
    
    //MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: CHECK IF USER is LOGGED IN
        loadBasketFromFirestore()
    }
    
    //MARK: IBACTIONS
    
    @IBAction func checkOutButtonPressed(_ sender: Any) {
    }
    
    //MARK: DOWNLOAD BASKET
    
    private func loadBasketFromFirestore() {
        downloadBasketFromFirestore("1234") { (basket) in
            self.basket = basket
            self.getBasketItems()
        }
    }
    private func getBasketItems() {
        if basket != nil {
            downloadItems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabel(false)
                self.tableView.reloadData()
            }
        }
    }
    //MARK: Helper Functions
    private func updateTotalLabel(_ isEmpty: Bool) {
        if isEmpty {
            itemTotalLabel.text = "0"
            totalAmountLabel.text = returnBasketTotalPrice()
        } else {
            itemTotalLabel.text = "\(allItems.count)"
            totalAmountLabel.text = returnBasketTotalPrice()
        }
        checkOutButtonStatusUpdate()
    }
    // TODO: UPdate THE Button Status
    
    private func returnBasketTotalPrice () -> String {
        var totalPrice = 0.0
        for item in allItems {
            totalPrice += item.price
        }
        return "Total Price:" + convertToCurrency(totalPrice)
    }
    //MARK: NAvigation
    private func showItemView(withItem: Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: Control CheckOut Button
    private func checkOutButtonStatusUpdate() {
        checkOutOutlet.isEnabled = allItems.count > 0
        if checkOutOutlet.isEnabled {
            checkOutOutlet.backgroundColor = .cyan
        } else {
            disableCheckOutButton()
        }
    }
    private func disableCheckOutButton() {
        checkOutOutlet.isEnabled = false
        checkOutOutlet.backgroundColor = .gray
    }
    private func removeItemFromBasket(itemId: String) {
        for i in 0..<basket!.itemIds.count {
            if itemId == basket!.itemIds[i] {
                basket!.itemIds.remove(at: i)
                
                return
            }
        }
    }

}
extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    //MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemId: itemToDelete.id)
            updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket!.itemIds]) { (error) in
                if error != nil {
                    print("Error updating the Basket", error!.localizedDescription)
                }
                self.getBasketItems()
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
    
    
}
