//
//  ContentsViewController.swift
//  DropBox
//
//  Created by Marutharaj Kuppusamy on 3/14/19.
//

import UIKit
import Reachability

class ContentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ContentsRepositoriesDelegate {
    
    var contentTableView: UITableView!
    var contents: Contents!
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    var contentViewModel: ContentViewModel!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl.addTarget(self, action: #selector(refreshContentData), for: .valueChanged)
        addContentTableView()
        addConstraintToTableView()
        contentViewModel = ContentViewModel(service: ContentsService())
        contentViewModel.delegate = self
        contentViewModel.query = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability()?.connection != .none {
            showActivityIndicator()
            contentViewModel.query = Constants.contentServiceQuery
        } else {
            showInternetConnectionUnavailableAlert()
        }
    }
    
    // MARK: - Private Methods
    
    @objc private func refreshContentData() {
        // Fetch content data
        showActivityIndicator()
        contentViewModel.query = Constants.contentServiceQuery
    }
    
    private func showActivityIndicator() {
        // Add it to the view where you want it to appear
        self.view.addSubview(activityIndicator)
        
        // Set up its size (the super view bounds usually)
        activityIndicator.frame = view.bounds
        // Start the loading animation
        activityIndicator.startAnimating()
    }
    
    private func showInternetConnectionUnavailableAlert() {
        let alert = UIAlertController(title: "DropBox", message: Constants.internetConnectionMessage, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    // add table view to load content
    private func addContentTableView() {
        // Calculate display width and height for table view
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        contentTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        contentTableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: Constants.contentTableViewCellIdentifier)
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentTableView.estimatedRowHeight = UITableView.automaticDimension
        contentTableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 10.0, *) {
            contentTableView.refreshControl = refreshControl
        } else {
            contentTableView.addSubview(refreshControl)
        }
        self.view.addSubview(contentTableView)
    }
    
    // Add constraint to table view
    private func addConstraintToTableView() {
        contentTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contents = self.contents {
            return contents.content.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contentTableViewCellIdentifier, for: indexPath) as? ContentsTableViewCell
        
        let contents = self.contents.content[indexPath.row]
        
        cell?.contentTitleLabel.text = contents.title
        if let description = contents.description {
            //cell?.updateConstraintDescriptionLabel(description: description)
            cell?.contentDescriptionLabel.text = description
        }
        if Reachability()?.connection != .none {
            if let imageHref = contents.imageHref {
                if let url = URL(string: imageHref) {
                    if let data = try? Data(contentsOf: url) {
                        cell?.contentImageView.image = UIImage(data: data)
                    } else {
                        cell?.contentImageView.image = UIImage(named: Constants.emptyImageIconName)
                    }
                } else {
                    cell?.contentImageView.image = UIImage(named: Constants.emptyImageIconName)
                }
            } else {
                cell?.contentImageView.image = UIImage(named: Constants.emptyImageIconName)
            }
        } else {
            showInternetConnectionUnavailableAlert()
        }
        
        return cell!
    }
    
    // MARK: - ContentsRepositoriesDelegate
    
    //To load content data in the table view once received data from the server
    func contentResultsDidChanged() {
        DispatchQueue.main.async {
            self.contents = self.contentViewModel.contents
            // Set navigation bar title as content title
            if let navigationController = self.navigationController {
                if let topItem = navigationController.navigationBar.topItem {
                    topItem.title = self.contents.title
                }
            }
            self.activityIndicator.removeFromSuperview()
            self.refreshControl.endRefreshing()
            self.contentTableView.reloadData()
        }
    }
}
