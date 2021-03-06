//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation
import FMDB

// Repository + CREATE IF EXISTS TABLE
extension Repository {
    open class Table {
        open class var tableName: String {
            return ""
        }
        
        open class var createIfExistTableQuery: String {
            return ""
        }
        
        open class var dropTableQuery: String {
            return ""
        }

        open class var alertIfExistsTableQuery: String {
            return ""
        }
        
        open class var itemType: Repository.Table.Item.Type {
            return Repository.Table.Item.self
        }
    }
}

extension Repository.Table {
    open class Item: NSObject {
        public override init() {
            super.init()
        }

        public required init?(_ resultSet: Repository.ResultSet) {
            super.init()
        }
        
        open class func object<E: Repository.Table.Item>(_ type: E.Type, resultSet: Repository.ResultSet) -> E? {
            return type.init(resultSet)
        }

        open class func list<E: Repository.Table.Item>(_ type: E.Type, resultSet: Repository.ResultSet) -> [E] {
            var list = [E]()
            while resultSet.result.next() {
                if let item = type.init(resultSet) {
                    list.append(item)
                }
            }
            return list
        }
    }
}

extension Repository.Table {
    open class func lastRowId(_ database: Repository.Database) -> Result<Repository.SuccessCode, Repository.ErrorCode> {
        let query = "SELECT last_insert_rowid();"
        let result = Repository.Action.select(database, query: query)
        if case let .failure(errorCode) = result {
            return .failure(errorCode)
        } else if case let .success(resultSet) = result {
            resultSet.result.next()
            let rowId = Int(resultSet.result.int(forColumnIndex: 0))
            return .success(.rowId(database, rowId))
        } else {
            fatalError()
        }
    }

    open class func count(_ database: Repository.Database, whereQuery: String = "", arguments: [Any] = []) -> Result<Repository.SuccessCode, Repository.ErrorCode> {
        let query = "SELECT COUNT(*) AS CNT FROM \(self.tableName)\(whereQuery == "" ? "" : " \(whereQuery)");"
        let result = Repository.Action.select(database, query: query, arguments: arguments)
        if case let .failure(errorCode) = result {
            return .failure(errorCode)
        } else if case let .success(resultSet) = result {
            resultSet.result.next()
            let cnt = Int(resultSet.result.int(forColumn: "CNT"))
            return .success(.count(database, cnt))
        } else {
            fatalError()
        }
    }
    
    open class func list(_ database: Repository.Database, whereQuery: String = "", arguments: [Any] = []) -> Result<Repository.SuccessCode, Repository.ErrorCode> {
        let query = "SELECT * FROM \(self.tableName)\(whereQuery == "" ? "" : " \(whereQuery)");"
        let result = Repository.Action.select(database, query: query, arguments: arguments)
        if case let .failure(errorCode) = result {
            return .failure(errorCode)
        } else if case let .success(resultSet) = result {
            let list = self.itemType.list(self.itemType, resultSet: resultSet)
            return .success(.list(database, list))
        } else {
            fatalError()
        }
    }

    open class func object(_ database: Repository.Database, whereQuery: String = "", arguments: [Any] = []) -> Result<Repository.SuccessCode, Repository.ErrorCode> {
        let query = "SELECT * FROM \(self.tableName)\(whereQuery == "" ? "" : " \(whereQuery)");"
        let result = Repository.Action.select(database, query: query, arguments: arguments)
        if case let .failure(errorCode) = result {
            return .failure(errorCode)
        } else if case let .success(resultSet) = result {
            resultSet.result.next()
            let item = self.itemType.object(self.itemType, resultSet: resultSet)
            return .success(.object(database, item))
        } else {
            fatalError()
        }
    }

    open class func delete(_ database: Repository.Database, whereQuery: String = "", arguments: [Any] = []) -> Result<Repository.SuccessCode, Repository.ErrorCode> {
        let query = "DELETE FROM \(self.tableName)\(whereQuery == "" ? "" : " \(whereQuery)");"
        let result = Repository.Action.delete(database, query: query, arguments: arguments)
        if case let .failure(errorCode) = result {
            return .failure(errorCode)
        } else if case .success = result {
            return .success(.delete(database))
        } else {
            fatalError()
        }
    }
}
