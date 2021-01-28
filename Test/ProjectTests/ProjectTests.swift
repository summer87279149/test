import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import Test
class ProjectTests: XCTestCase {
    
    var viewModel = GithubViewModel()
    
    var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        viewModel.clearCache()
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testGetTheLatestRecord(){
        viewModel.save(string: "test")
        viewModel.save(string: "test2")
        viewModel.save(string: "test3")
        let latest = viewModel.getHistory().last
        XCTAssertEqual("test3", latest)
    }
    
    func testClearCache()throws {
        viewModel.save(string: "test")
        viewModel.save(string: "test2")
        viewModel.save(string: "test3")
        viewModel.clearCache()
        let result = viewModel.getHistory()
        XCTAssertEqual([], result)
    }
    
    func testSaveAndGetHistory()throws {
        viewModel.save(string: "test")
        let result = viewModel.getHistory()
        XCTAssertEqual(["test"], result)
        
        viewModel.save(string: "test2")
        let result2 = viewModel.getHistory()
        XCTAssertEqual(["test","test2"], result2)
        
        viewModel.save(string: "")
        let result3 = viewModel.getHistory()
        XCTAssertEqual(["test","test2",""], result3)
    }
    
    func testGithubApi() throws {
        
        let exp = expectation(description: "")
        var result = ""
        viewModel.githubApi()
            .subscribe(onNext: {
                result = $0
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [exp], timeout: 30)
        XCTAssertTrue(result.count > 0)
    }
    
    
    
}
