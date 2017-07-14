//
//  ViewController.swift
//  LastFM
//
//  Created by Andrea Murru on 13/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import UIKit
import RxSwift



class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    var viewModel: MainViewModel?
    

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView?.delegate = self
        tableView?.dataSource = self

        viewModel = MainViewModel()
        viewModel?.startTest(text: "cher", completion: { (result) in
            if result {
                self.tableView?.reloadData()
            }
        })
    }
    

}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainSection.count()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MainSection(rawValue: section) else { return 1 }
        
        switch section {
        case .Song:
            return (viewModel?.songArray.count) ?? 0
        case .Artist:
            return (viewModel?.artistArray.count) ?? 0
        case .Album:
            return (viewModel?.albumArray.count) ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = MainSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Song:
            return cellForSongSectionForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        case .Album:
            return cellForAlbumSectionForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        case .Artist:
            return cellForArtistSectionForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = MainSection(rawValue: section) else { return "" }
        return section.sectionTitle()
    }
    
    private func cellForAlbumSectionForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView?.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath as IndexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.mainLabel?.text = viewModel?.albumArray[indexPath.row].name
        
        return cell
    }
    
    private func cellForSongSectionForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView?.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath as IndexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.mainLabel?.text = viewModel?.songArray[indexPath.row].name
        
        return cell
    }
    
    private func cellForArtistSectionForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView?.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath as IndexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.mainLabel?.text = viewModel?.artistArray[indexPath.row].name
        
        return cell
    }
    
}
