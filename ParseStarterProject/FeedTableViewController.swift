//
//  FeedTableViewController.swift
//  InstagramClone
//
//  Created by Guilherme Henrique Crozariol on 2017-01-12.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var users = [String: String]()
    var usernames = [String]()
    var messages = [String]()
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                self.users.removeAll()
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                    
                }
                
            }
            
            let getFollowedUsersQuery = PFQuery(className: "Followers")
            
            getFollowedUsersQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                    
                    for object in followers {
                        
                        if let follower = object as? PFObject {
                            
                            let followedUser = follower["following"] as! String
                            
                            let query = PFQuery(className: "Posts")
                            
                            query.whereKey("userid", equalTo: followedUser)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    
                                    for object in posts {
                                        
                                        if let post = object as? PFObject {
                                            
                                            self.messages.append(post["message"] as! String)
                                            
                                            self.imageFiles.append(post["imageFile"] as! PFFile)
                                            
                                            self.usernames.append(self.users[post["userid"] as! String]!)
                                            
                                            self.tableView.reloadData()
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            })
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
            
                if let downloadedImage = UIImage(data: imageData) {
                
                    cell.postedImage.image = downloadedImage
                
                }
                
            }
            
        }
        
        cell.postedImage.image = UIImage(named: "person_icon.png")
        cell.usernameLabel.text = usernames[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]

        return cell
    }

}
