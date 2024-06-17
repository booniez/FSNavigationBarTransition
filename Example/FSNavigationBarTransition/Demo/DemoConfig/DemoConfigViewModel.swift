//
//  DemoConfigViewModel.swift
//  NavigationBarTransition_Example
//
//  Created by yuanl on 2024/6/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DemoConfigViewModel {
    // 因为数据会改变，所以这里用 BehaviorSubject
    let items = BehaviorSubject<[[DemoConfigModel]]>(value: [
        [
            DemoConfigModel(isChecked: false, title: "Hidden", color: nil),
            DemoConfigModel(isChecked: false, title: "Transparent", color: nil),
            DemoConfigModel(isChecked: false, title: "Translucent", color: nil),
            DemoConfigModel(isChecked: true, title: "Black Bar Style", color: nil),
            DemoConfigModel(isChecked: false, title: "Shadow Image", color: nil),
        ],
        [
            DemoConfigModel(isChecked: false, title: "None", color: nil),
            DemoConfigModel(isChecked: false, title: "Black", color: .black),
            DemoConfigModel(isChecked: false, title: "White", color: .white),
            DemoConfigModel(isChecked: false, title: "TableView Background Color", color: .gray),
            DemoConfigModel(isChecked: false, title: "Red", color: .red),
        ],
        [
            DemoConfigModel(isChecked: false, title: "Green", color: .green),
            DemoConfigModel(isChecked: false, title: "Blue", color: .blue),
            DemoConfigModel(isChecked: false, title: "Purple", color: .purple),
            DemoConfigModel(isChecked: false, title: "Red", color: .red),
            DemoConfigModel(isChecked: false, title: "Yellow", color: .yellow),
        ],
        [
            DemoConfigModel(isChecked: false, title: "Dynamic Gradient Bar", color: .green),
        ]
        
    ])
    
    private let disposeBag = DisposeBag()
    
    // 业务逻辑方法，例如，更新特定索引的Item的选中状态
    func updateItem(at index: IndexPath) {
        // 先获取当前的items
        if var currentItems = try? items.value() {
            // 切换选中状态
            currentItems[index.section][index.row].isChecked = !currentItems[index.section][index.row].isChecked
            // 发出新的items
            items.onNext(currentItems)
        }
    }
}
