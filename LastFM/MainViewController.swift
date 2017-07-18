//
//  ViewController.swift
//  LastFM
//
//  Created by Andrea Murru on 13/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var viewModel = MainViewModel()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView?.delegate = self
        tableView?.dataSource = nil
        
        viewModel.startTest(text: "cher")
        
        
        if let tableView = tableView {
            viewModel.artistArray.asObservable().subscribe(onNext: { (artist) in
                print("\(artist)")
            }, onError: { (error) in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).addDisposableTo(disposeBag)
            
            
            viewModel.artistArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "ListTableViewCell", cellType: ListTableViewCell.self)) {
                (index,model,cell) in
                
                let viewModelCell = CellViewModel(artist: model)
                
                cell.configure(withViewModel: viewModelCell)
                
                }.addDisposableTo(disposeBag)
        }
        viewModel.startTest(text: "cher")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.viewModel.startTest(text: "eminem")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.viewModel.startTest(text: "madonna")
        })
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
}

//extension MainViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return MainSection.count()
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let section = MainSection(rawValue: section) else { return 1 }
//
//        switch section {
//        case .Song:
//            return (viewModel?.songArray.count) ?? 0
//        case .Artist:
//            return (viewModel?.artistArray.count) ?? 0
//        case .Album:
//            return (viewModel?.albumArray.count) ?? 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let section = MainSection(rawValue: indexPath.section) else { return UITableViewCell() }
//
//        var viewModelCell: CellRepresentable?
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else { fatalError("Unexpected Table View Cell")
//        }
//
//
//        switch section {
//        case .Song:
//            viewModelCell = CellViewModel(song: viewModel?.songArray[indexPath.row])
//        case .Album:
//            viewModelCell = CellViewModel(album: viewModel?.albumArray[indexPath.row])
//        case .Artist:
//            viewModelCell = CellViewModel(artist: viewModel?.artistArray[indexPath.row])
//        }
//
//        if let viewModelCell = viewModelCell {
//            cell.configure(withViewModel: viewModelCell)
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let section = MainSection(rawValue: section) else { return "" }
//        return section.sectionTitle()
//    }
//}
