//
//  ViewController.swift
//  PALFMDB
//
//  Created by pikachu987 on 01/16/2021.
//  Copyright (c) 2021 pikachu987. All rights reserved.
//

import UIKit
import PALFMDB

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Repository.tables = [Repository.Test.self, Repository.Example.self]
        let database = Repository.database
        let createIfExistTableResult = Repository.createIfExistsTable(database)
        if case let .success(.default(_, query)) = createIfExistTableResult {
            print("success: \(query)")
        } else if case let .failure(.createIfExistTable(_, query, lastErrorMessage)) = createIfExistTableResult {
            print("failure: \(query)\nlastErrorMessage: \(lastErrorMessage)")
        }
        database.close()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let database = Repository.database
            
            let listResult = Repository.Test.list(database)
            if case let .success(.list(_, query, list)) = listResult {
                print("success: \(query)")
                print(list)
            } else if case let .failure(.select(_, query, lastErrorMessage)) = listResult {
                print("failure: \(query)\nlastErrorMessage: \(lastErrorMessage)")
            }
            
            let insertResult = Repository.Test.insert(database, test: "Test1", example: "Example1")
            if case let .success(.insert(_, query)) = insertResult {
                print("success: \(query)")
            } else if case let .failure(.insert(_, query, lastErrorMessage)) = insertResult {
                print("failure: \(query)\nlastErrorMessage: \(lastErrorMessage)")
            }
            
            let insertResult2 = Repository.Test.insert(database, test: "Test2", example: "Example2")
            if case let .success(.insert(_, query)) = insertResult2 {
                print("success: \(query)")
            } else if case let .failure(.insert(_, query, lastErrorMessage)) = insertResult2 {
                print("failure: \(query)\nlastErrorMessage: \(lastErrorMessage)")
            }
            
            let insertResult3 = Repository.Test.insert(database, test: "Test3", example: "Example3")
            if case let .success(.insert(_, query)) = insertResult3 {
                print("success: \(query)")
            } else if case let .failure(.insert(_, query, lastErrorMessage)) = insertResult3 {
                print("failure: \(query)\nlastErrorMessage: \(lastErrorMessage)")
            }
            
            let lastRowidResult = Repository.Test.lastRowid(database)
            if case let .success(.rowid(_, query, rowid)) = lastRowidResult {
                print("success: \(query), rowid: \(rowid)")
            } else if case let .failure(.insert(_, query, lastErrorMessage)) = lastRowidResult {
                print("failure: \(query)\nlastErrorMessage: \(lastErrorMessage)")
            }
            
            let listResult2 = Repository.Test.list(database)
            if case let .success(.list(_, query, list)) = listResult2 {
                print("success: \(query)")
                print(list)
            } else if case let .failure(.select(_, query, lastErrorMessage)) = listResult2 {
                print("failure: \(query)\nlastErrorMessage: \(lastErrorMessage)")
            }
            
            database.close()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Repository {
    final class Test: Repository.Table {
        override class var tableName: String {
            return "TestTable"
        }
        
        override class var createIfExistTableQuery: String {
            return "CREATE TABLE IF NOT EXISTS \(self.tableName) (" +
                "SEQ INTEGER PRIMARY KEY AUTOINCREMENT," +
                "TEST VARCHAR," +
                "EXAMPLE VARCHAR" +
                ");"
        }

        override class var itemType: Repository.Table.Item.Type {
            return Repository.Test.Item.self
        }

        open class Item: Repository.Table.Item {
            var seq: Int
            var test: String
            var example: String

            open override var description: String {
                return "seq: \(self.seq), test: \(self.test), example: \(self.example)"
            }

            public required init?(_ resultSet: Repository.ResultSet) {
                self.seq = Int(resultSet.result.int(forColumn: "SEQ"))
                self.test = resultSet.result.string(forColumn: "TEST") ?? ""
                self.example = resultSet.result.string(forColumn: "EXAMPLE") ?? ""
                super.init(resultSet)
            }
        }
        
        static func insert(_ database: Repository.Database, test: String, example: String) -> Result<Repository.SuccessCode, Repository.ErrorCode> {
            let query = "INSERT INTO \(self.tableName) (TEST, EXAMPLE) VALUES (?, ?);"
            let result = Repository.Action.insert(database, query: query, arguments: [test, example])
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case .success = result {
                return .success(.insert(database, query))
            } else {
                fatalError()
            }
        }
    }
}

extension Repository {
    final class Example: Repository.Table {
        override class var tableName: String {
            return "ExampleTable"
        }
        
        override class var createIfExistTableQuery: String {
            return "CREATE TABLE IF NOT EXISTS \(self.tableName) (" +
                "SEQ INTEGER PRIMARY KEY AUTOINCREMENT," +
                "EXAMPLE VARCHAR" +
                ");"
        }
    }
}
