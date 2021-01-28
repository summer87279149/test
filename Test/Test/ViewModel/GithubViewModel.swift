import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
class GithubViewModel {
    
    let history = BehaviorRelay<[String]>(value: [])
    
    let key = "someKey"
    let url = "https://api.github.com"
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    let userDefault = UserDefaults.standard
    
    init() {
        history.accept(getHistory())
    }
    
    func githubApi() -> Observable<String> {
        return session.rx
            .json(url: URL(string: self.url)!)
            .map {
                return JSON($0).rawString() ?? ""
            }
    }
    
    func save(string:String) {
        if var array = userDefault.array(forKey: key) as? [String]{
            array.append(string: string, forKey: key)
        }else{
            var array:[String] = []
            array.append(string: string, forKey: key)
        }
        history.accept(getHistory())
    }
    
    func getHistory() -> [String] {
        if let array = userDefault.array(forKey: key) as? [String]{
            return array
        }
        return []
    }
}

fileprivate extension Array where Element == String{
    mutating func append(string:String,forKey key:String)  {
        self.append(string)
        UserDefaults.standard.setValue(self, forKey: key)
    }
}
