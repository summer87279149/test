//
//  ViewController.swift
//  Test
//
//  Created by 夏天 on 2021/1/28.
//

import UIKit
import RxSwift
import RxCocoa
class MainVC: UIViewController {
    
    @IBOutlet weak var resultView: UITextView!
    
    let disposeBag = DisposeBag()
    
    let viewModel = GithubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTheLatestRecord()
        startRequest()
    }

    func getTheLatestRecord() {
        resultView.text = viewModel.getHistory().last
    }
    
    func startRequest()  {
        let results = Driver<Int>
            .interval(.seconds(5))
            .flatMapLatest { [unowned self] _ in
                self.viewModel.githubApi().asDriver(onErrorJustReturn: "")
            }

        results
            .do { [unowned self] in
                self.viewModel.save(string:$0)
            }
            .drive(resultView.rx.text)
            .disposed(by: disposeBag)
    }
    
    @IBAction func push(_ sender: Any) {
        let vc = HistoryVC(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

