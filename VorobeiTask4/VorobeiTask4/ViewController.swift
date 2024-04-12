//
//  ViewController.swift
//  VorobeiTask4
//
//  Created by Даниил Павленко on 12.04.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.delegate = self
        return tableView
    }()

    
    lazy var dataSource: UITableViewDiffableDataSource<String, String> = {
        return UITableViewDiffableDataSource<String, String>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = itemIdentifier
            cell?.accessoryType = self.selectedItems.contains(itemIdentifier) ? .checkmark : .none
            return cell
        }
    }()
    
    var data: [String] = []
    var selectedItems: [String] = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupTableView()
    }
    
    //MARK: - Methods
    func setupTableView() {
        navigationItem.title = "Task 4"
        for i in 0...50 {
            data.append(String(i))
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = .init(title: "Shuffle", primaryAction: .init(handler: { _ in
            self.updateData(self.data.shuffled(), animated: true)
        }))
        updateData(data, animated: false)
        view.addSubview(tableView)
    }
    
    func updateData(_ data: [String], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        
        snapshot.appendSections(["section"])
        snapshot.appendItems(data, toSection: "section")
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = dataSource.itemIdentifier(for: indexPath) {
            if self.selectedItems.contains(item) {
                selectedItems = selectedItems.filter { $0 != item }
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                
            } else {
                selectedItems.append(item)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                if let first = dataSource.snapshot().itemIdentifiers.first, first != item {
                    var snapshot = dataSource.snapshot()
                    snapshot.moveItem(item, beforeItem: first)
                    dataSource.apply(snapshot)
                }
            }
        }
    }
}
