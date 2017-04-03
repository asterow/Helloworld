//
//  DynamiqueTableViewController.swift
//  Helloworld
//
//  Created by Astero on 22/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit

class DynamiqueTableViewController: UITableViewController {

    var quotes: [Quote] = []
//    var quotes: [Quote] = [Quote(author:"Yoda", body:"May the force be with you !"), Quote(author:"Tarzan", body:"HMM HMM HUG"), Quote(author:"Macron", body:"blablabla bla bla blablabla BLABLA BLAAAAA")]
//    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let path = Bundle.main.path(forResource: "quotes", ofType: "plist"), let data = NSArray(contentsOfFile: path) as? [Dictionary<String, String>] {
            
            quotes = data.map { Quote(author: $0["author"] ?? "unknown", body: $0["body"] ?? "unknown") }
            
//            for dict in (data as! [Dictionary<String, String>]){
//                quotes.append(Quote(author: dict["author"] ?? "unknown", body: dict["body"] ?? "unknown"))
//            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "classicCell1", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as? QuoteTableViewCell
        
        cell?.quote = quotes[indexPath.row]
        cell?.quoteLabel.text = quotes[indexPath.row].body
//        cell.detailTextLabel?.text = quotes[indexPath.row].author
        print(indexPath)
        return cell!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quoteDetailSegue" {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                print("no selection while preparing segue: quoteDetailSegue")
                return
            }
            guard let quoteDetailViewController = segue.destination as? quoteDetailViewController else {
                print("quoteDetail segue destination controller should be of type quoteDetailViewController")
                return
            }
            quoteDetailViewController.quote = quotes[selectedIndexPath.row]
//            if let cell = sender as? QuoteTableViewCell{
////                , let indexPath = tableView.indexPath(for: cell)
//                quoteDetailViewController.quote = cell.quote
//                //quoteDetailViewController.quote = quotes[indexPath.row]
//            }
        }
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
