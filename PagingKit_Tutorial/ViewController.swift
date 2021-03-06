//
//  ViewController.swift
//  PagingKit_Tutorial
//
//  Created by SeongMinK on 2021/10/13.
//

import UIKit
import PagingKit

class ViewController: UIViewController {
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!

    static var viewController: (UIColor) -> UIViewController = { (color) in
        let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }
    
    var dataSource = [(menuTitle: "test1", vc: viewController(.red)), (menuTitle: "test2", vc: viewController(.blue)), (menuTitle: "test3", vc: viewController(.yellow))]
    
    lazy var firstLoad: (() -> Void)? = { [weak self, menuViewController, contentViewController] in
        menuViewController?.reloadData()
        contentViewController?.reloadData()
        self?.firstLoad = nil
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstLoad?()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(#fileID, #function, "called")
        
//        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: "titleLabelMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
//        menuViewController.registerFocusView(view: UnderlineFocusView())
        
        menuViewController.cellAlignment = .center

//        menuViewController.reloadData()
//        contentViewController.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let vc = segue.destination as? PagingMenuViewController {
             menuViewController = vc
             menuViewController.dataSource = self // <- set menu data source
             menuViewController.delegate = self // <- set menu delegate
         } else if let vc = segue.destination as? PagingContentViewController {
             contentViewController = vc
             contentViewController.dataSource = self
             contentViewController.delegate = self
         }
     }
}

// ?????? ????????? ??????
extension ViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    // ?????? ??????
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return 100
    }
    
    // ????????? ?????? ??? ??????
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
//        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "titleLabelMenuCell", for: index) as! TitleLabelMenuViewCell
        cell.titleLabel.text = dataSource[index].menuTitle
        cell.titleLabel.textColor = .black
        return cell
    }
}

// ?????? ????????? ?????????
extension ViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

// ????????? ????????? ??????
extension ViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].vc
    }
}

// ????????? ????????? ?????????
extension ViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        // ???????????? ????????? ?????? ????????? ?????????
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
