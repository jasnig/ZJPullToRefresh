//
//  ViewController.swift
//  PullToRefresh
//
//  Created by ZeroJ on 16/7/20.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    static let cellID = "cellID"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 30.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //        tableView.zj_startHeaderAnimation()
        
    }
    
    deinit {
        print("xiaoghui-----\(self)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(ViewController.cellID)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: ViewController.cellID)
        }
        var text = ""
        if indexPath.row == 0 {
            text = "使用正常状态且不自定义的header和footer"
        }
        else if indexPath.row == 1 {
            text = "使用正常状态且隐藏的header的显示时间"

        }
        else if indexPath.row == 2 {
            text = "使用正常状态且自定义文字提示和时间显示"

        }
        else if indexPath.row == 3 {
            
            text = "使用gif图片且不自定义"
        }
        else if indexPath.row == 4 {
            text = "使用gif图片且隐藏文字提示"
            
        }
        else if indexPath.row == 5 {
            text = "使用gif图片且自定义文字提示"

        }
        else {
            text = "分离开自定义的设置"
            
        }
        cell?.textLabel?.text = text
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "header"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let testVc = TestController()
        testVc.row = indexPath.row
        showViewController(testVc, sender: nil)
    }
}

