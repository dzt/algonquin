//
//  CoursesTableViewController.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/24/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import UIKit
import RealmSwift

class CoursesTableViewController: UITableViewController {
    
    var courses: [Course]?
    private var activityIndicator: UIActivityIndicatorView!
    private var errorLabel: UILabel!
    let realm = try! Realm()
    
    struct Storyboard {
        static let courseCell = "CourseCell"
        static let showCourseDetail = "courseDetail"
    }
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        if realm.objects(Account.self).count == 0 {
            self.performSegue(withIdentifier: "logInAtHome", sender: nil)
        }
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        studentImage.layer.cornerRadius = self.studentImage.frame.size.width / 2
        
        errorLabel = UILabel()
        errorLabel.alpha = 0
         errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.black
        view.addSubview(errorLabel)
        
        if realm.objects(Account.self).count == 1 {
            getCourses()
        }
        self.tableView.reloadData()
        
    }
    
    func getCourses() {
        Client.shared.parser.getSummary(userid: realm.objects(Account.self)[0].userid, password: realm.objects(Account.self)[0].password) { summary, error in
            guard let summary = summary else {
                print("Error while collecting Course Summary: \(error)")
                self.courses = [Course]()
                self.tableView.reloadData()
                self.errorLabel.alpha = 1
                self.errorLabel.text = "There was an issue retrieving your courses. Please try again later."
                self.activityIndicator.stopAnimating()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.refreshControl?.endRefreshing()
                return
            }
            
            
            DispatchQueue.main.async {
                
                self.courses = summary.courses
                self.fullName.text = summary.student
                self.studentID.text = "#\(summary.id!) - Grade \(summary.grade!)"
                
                if let pictureDecoded = UIImage(data: Utils.decodeBase64(encodedData: summary.photo!)) {
                    
                    self.studentImage.image = pictureDecoded
                    self.studentImage.contentMode = .scaleAspectFill

                }

                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 0
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.navigationItem.title = "Courses"
            }
        }
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getCourses()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.sizeToFit()
        activityIndicator.frame = CGRect(x: (view.frame.size.width - activityIndicator.frame.size.width) / 2, y: (view.frame.size.height - activityIndicator.frame.size.height) / 2, width: activityIndicator.frame.size.width, height: activityIndicator.frame.size.height)
        
        let errorLabelFrame = errorLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: view.frame.size.width - 64, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 10)
        errorLabel.frame = CGRect(x: (view.frame.size.width - errorLabelFrame.size.width) / 2, y: (view.frame.size.height - errorLabelFrame.size.height) / 2, width: errorLabelFrame.size.width, height: errorLabelFrame.size.height)
    }
    
}

extension CoursesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let courses = courses {
            return courses.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.courseCell, for: indexPath) as! CoursesTableViewCell
        
        cell.course = self.courses?[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CoursesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Storyboard.showCourseDetail, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showCourseDetail {
            if let dropDetailTVC = segue.destination as? CourseDetailTableViewController {
                let selectedCourse = self.courses?[(sender as! IndexPath).row]
                dropDetailTVC.course = selectedCourse
            }
        }
    }
    
}
