//
//  ViewController.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 14/04/2023.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var tableView : UITableView!
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setup(searchInput: textField.rx.text.asObservable())
        viewModel.validCityName.map {
            $0 ? UIColor.black : UIColor.red
        }.bind(to: textField.rx.textColor).disposed(by: disposeBag)
        viewModel.foundCities.bind(to: tableView.rx.items(cellIdentifier: "SearchCell")) { (index, cities, cell) in
            cell.textLabel?.text = cities.locationDescription
            cell.textLabel?.textColor = .black
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.showDetailedWeather(indexPath)
            self.viewModel.saveCity(indexPath: indexPath)
        }.disposed(by: disposeBag)
    }

    func showDetailedWeather(_ indexPath : IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WeatherDetails") as? WeatherDetailsViewController else { return }
        vc.viewModel = viewModel.getDetailsViewModel(indexPath: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

