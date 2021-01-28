//
//  HistoryVC.swift
//  Test
//
//  Created by 夏天 on 2021/1/28.
//

import UIKit
import RxSwift
import RxCocoa

let identifier = "testIdentifier"
class HistoryVC: UIViewController {
    

    var tableView : UITableView!
    
    var viewModel = GithubViewModel()
    
    let disposeBag = DisposeBag()
    
    init(viewModel:GithubViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "history"
        createTableView()
        bindDataSource()
    }
    
    func createTableView(){
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func bindDataSource(){
        viewModel.history
            .bind(to: tableView.rx.items) { (tb, row, value) -> UITableViewCell in
                let cell = tb.dequeueReusableCell(withIdentifier: identifier) as! MyTableViewCell
                cell.numberLabel?.text = "No. \(row + 1), data ="
                cell.detailLabel?.text = value
                return cell
            }
            .disposed(by: disposeBag)
    }
    
}
