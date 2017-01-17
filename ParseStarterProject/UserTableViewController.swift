//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Rob Percival on 07/07/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var usernames = [""]
    var userIDs = [""]
    var isFollowing = ["" : false]
    var refresher = UIRefreshControl()
    
    
    @IBAction func logOut(_ sender: AnyObject) {
        PFUser.logOut()
        performSegue(withIdentifier: "backToMainSegue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func refresh() {
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if error != nil {
                
                print(error as Any)
                
            } else if let users = objects {
                
                self.usernames.removeAll()
                self.userIDs.removeAll()
                self.isFollowing.removeAll()
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.current()?.objectId {
                            
                            let showUsername = user.username!
                            
                            self.usernames.append(showUsername)
                            self.userIDs.append(user.objectId!)
                            
                            let query = PFQuery(className: "Followers")
                            
                            query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let objects = objects {
                                    
                                    if objects.count > 0 {
                                        
                                        self.isFollowing[user.objectId!] = true
                                        
                                    } else {
                                        
                                        self.isFollowing[user.objectId!] = false
                                        
                                    }
                                    
                                    if self.isFollowing.count == self.usernames.count {
                                        
                                        self.tableView.reloadData()
                                        self.refresher.endRefreshing()
                                        
                                    }
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        
        refresher = UIRefreshControl()
        
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        if isFollowing[userIDs[indexPath.row]]! {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isFollowing[userIDs[indexPath.row]]! {
            
            isFollowing[userIDs[indexPath.row]] = false
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let query = PFQuery(className: "Followers")
            
            query.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            query.whereKey("following", equalTo: userIDs[indexPath.row])
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                        
                    }
                    
                }
                
            })
            
        } else {
            
            isFollowing[userIDs[indexPath.row]] = true
            
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            let following = PFObject(className: "Followers")
            
            following["follower"] = PFUser.current()?.objectId
            following["following"] = userIDs[indexPath.row]
            
            following.saveInBackground()
            
        }
        
    }
    
}
