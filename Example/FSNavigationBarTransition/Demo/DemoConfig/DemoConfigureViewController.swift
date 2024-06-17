//
//  DemoConfigureViewController.swift
//  NavigationBarTransition_Example
//
//  Created by yuanl on 2024/6/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import FSNavigationBarTransition

class DemoConfigureViewController: UIViewController {
    // MARK: - Properties
    var tableView: UITableView?
    var barHidden = false
    var transparent = false
    var translucent = false
    var shadowImage = false
    
    // MARK: - View Model
    let viewModel = DemoConfigViewModel()
    // MARK: - State
    let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTableView()
    }
    
    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = .cyan
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if let tableView = tableView {
            view.addSubview(tableView)
        }
        
    }
    
    // MARK: - Factories
    
    // MARK: - Methods
    
    private func bindTableView() {
        // 绑定items到tableView
        viewModel.items
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        // 绑定tableView的点击事件
//        tableView?.rx.itemSelected
//            .map { $0 }
//            .subscribe(onNext: { [weak self] index in
//                self?.viewModel.updateItem(at: index)
//                self?.tableView?.deselectRow(at: index, animated: true)
//                if index.section != 0 {
//                    self?.showNextViewControllerWithColor(index)
//                }
//            })
//            .disposed(by: disposeBag)
    }
    
    private func showNextViewControllerWithColor(_ index: IndexPath) {
        if (index.section == 3) {
            let gradientDemoViewController = GradientDemoViewController()
            navigationController?.pushViewController(gradientDemoViewController, animated: true)
            return
        }
        var conf: [NavigationBarConfigurations] = [.configurationsDefault]
        if try! viewModel.items.value()[0][0].isChecked {
            conf.append(.hidden)
        }
        if try! viewModel.items.value()[0][1].isChecked {
            conf.append(.backgroundStyleTransparent)
        } else if try! !viewModel.items.value()[0][2].isChecked {
            conf.append(.backgroundStyleOpaque)
        }
        
        if try! viewModel.items.value()[0][3].isChecked {
            conf.append(.styleBlack)
        }
        
        if try! viewModel.items.value()[0][4].isChecked {
            conf.append(.showShadowImage)
        }
        
        
        
        let demoContainerViewController = DemoContainerViewController()
        if let color = try! viewModel.items.value()[index.section][index.row].color {
            conf.append(.backgroundStyleColor)
            demoContainerViewController.backgroundColor = color
        }
        demoContainerViewController.configurations = conf
        if index.section == 1 {
            demoContainerViewController.type = "Color"
        } else if index.section == 2 {
            demoContainerViewController.type = "Image"
        }
        navigationController?.pushViewController(demoContainerViewController, animated: true)
        
    }
    
}

// MARK: UITableView Delegate Methods
extension DemoConfigureViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return try! viewModel.items.value().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return try! viewModel.items.value()[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Next Controller Bar Style"
        case 1:
            return "Colors"
        case 2:
            return "Images"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateItem(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section != 0 {
            showNextViewControllerWithColor(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "bar style 会影响状态栏的样式\nbar style 是 UIBarStyleBlack 的时候状态栏为白色\nbar style 是 UIBarStyleDefault 的时候状态栏为黑色"
        case 1:
            return "选择偏白的颜色的时候，关闭 Black Bar Style 展示效果更好"
        case 2:
            return "选择图片为背景的时候建议关掉半透明效果"
        case 3:
            return "style 根据页面滑动距离动态改变"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = try! viewModel.items.value()[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.accessoryType = item.isChecked ? .checkmark : .none
            cell.imageView?.image = nil
        } else {
            cell.accessoryType = .disclosureIndicator
            if let color = item.color {
                cell.imageView?.image = UIImage.image(withColor: color, size: CGSize(width: 44.0, height: 44.0))
            }
        }
        
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = item.title
        return cell
    }
    
    
}
