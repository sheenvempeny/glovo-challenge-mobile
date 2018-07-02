//
//  LocSelViewController.swift
//  GlovoTest
//
//  Created by sheen vempeny on 7/1/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import UIKit

class LocSelViewController: UIViewController {

    @IBOutlet weak var btnDone:UIBarButtonItem!
    @IBOutlet weak var tableView:UITableView!
    var countries:[Country]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMap(sender:Any){
        weak var pvc = self.presentingViewController as? ViewController
        self.dismiss(animated: false) {
            
            if  let indexPath = self.tableView.indexPathForSelectedRow {
                
                guard let cities = self.countries![indexPath.section].cities else{
                    return
                }
                
                let city = cities[indexPath.row]
                pvc?.citySelected(city: city)
            }
            
           
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LocSelViewController:UITableViewDelegate,UITableViewDataSource{
    
   func numberOfSections(in tableView: UITableView) -> Int{
        guard self.countries != nil else {
            return 0
        }
    
        return self.countries!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cities = self.countries![section].cities else{
            return 0
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cities = self.countries![indexPath.section].cities else{
            return UITableViewCell()
        }
        
        if let  cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = cities[indexPath.row].name
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.countries![section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.btnDone.isEnabled = true
    }
}


