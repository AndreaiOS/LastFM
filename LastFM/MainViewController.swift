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
import RxDataSources



class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var viewModel = MainViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var searchBar: UISearchBar?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let dataSource = RxTableViewSectionedAnimatedDataSource<ArtistSection>()
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .top,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .left)

//        dataSource.configureCell = { ds, tv, ip, item in
//            let cell = tv.dequeueReusableCell(withIdentifier: "ListTableViewCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ListTableViewCell")
//            cell.textLabel?.text = "Item \(item)"
//            
//            return cell
//        }
//        dataSource.titleForHeaderInSection = { ds, index in
//            return ds.sectionModels[index].header
//        }
        
        dataSource.configureCell = { (dataSource, table, idxPath, item) in
            let cell = table.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: idxPath)
            
            cell.textLabel?.text = "\(item.name)"
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { (ds, section) -> String? in
            return ds[section].header
        }

        
        if let tableView = tableView {
        

            
            viewModel.sections.asObservable()

                .bind(to: tableView.rx.items(dataSource: dataSource))

                .addDisposableTo(disposeBag)
            
            tableView.rx.setDelegate(self)
                .addDisposableTo(disposeBag)
            
        }
        viewModel.dataSource = dataSource

//
//        if let tableView = tableView {
//            viewModel.artistArray.asObservable().subscribe(onNext: { (artist) in
//             
//            }).addDisposableTo(disposeBag)
//            
//            
//            viewModel.artistArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "ListTableViewCell", cellType: ListTableViewCell.self)) {
//                (index,model,cell) in
//                
//                let viewModelCell = CellViewModel(artist: model)
//                
//                cell.configure(withViewModel: viewModelCell)
//                
//                }.addDisposableTo(disposeBag)
//        }
        
        searchBar?
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
                self.viewModel.startTest(text: query)
            })
            .addDisposableTo(disposeBag)
        
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
