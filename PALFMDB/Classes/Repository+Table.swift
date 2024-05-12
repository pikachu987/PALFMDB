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
            ""
        }
        
        open class var createIfExistTableQuery: String {
            ""
        }
        
        open class var dropTableQuery: String {
            ""
        }

        open class var alterIfExistsTableQuery: String {
            ""
        }
        
        open class var itemType: Repository.Table.Item.Type {
            Item.self
        }

        open class func lastRowId(_ database: Repository.Database) -> Result<Int, Repository.ErrorCode> {
            let query = "SELECT last_insert_rowid();"
            let result = Repository.Action.select(database, query: query)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                resultSet.result.next()
                let rowId = Int(resultSet.result.int(forColumnIndex: 0))
                return .success(rowId)
            } else {
                fatalError()
            }
        }

        open class func count(_ database: Repository.Database, 
                              addQuery: String = "",
                              arguments: [Any] = []) -> Result<Int, Repository.ErrorCode> {
            let query = "SELECT COUNT(*) AS CNT FROM \(tableName)\(addQuery == "" ? "" : " \(addQuery)");"
            let result = Repository.Action.select(database, query: query, arguments: arguments)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                resultSet.result.next()
                let cnt = Int(resultSet.result.int(forColumn: "CNT"))
                return .success(cnt)
            } else {
                fatalError()
            }
        }

        open class func list<T: Repository.Table.Item>(_ database: Repository.Database, 
                                                       column: String = "*",
                                                       addQuery: String = "",
                                                       arguments: [Any] = []) -> Result<[T], Repository.ErrorCode> {
            let query = "SELECT \(column) FROM \(tableName)\(addQuery == "" ? "" : " \(addQuery)");"
            let result = Repository.Action.select(database, query: query, arguments: arguments)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                let list = itemType.list(itemType, resultSet: resultSet).compactMap { $0 as? T }
                return .success(list)
            } else {
                fatalError()
            }
        }

        open class func listResultSet(_ database: Repository.Database, 
                                      column: String = "*",
                                      addQuery: String = "",
                                      arguments: [Any] = []) -> Result<FMResultSet, Repository.ErrorCode> {
            let query = "SELECT \(column) FROM \(tableName)\(addQuery == "" ? "" : " \(addQuery)");"
            let result = Repository.Action.select(database, query: query, arguments: arguments)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                return .success(resultSet.result)
            } else {
                fatalError()
            }
        }

        open class func object<T: Repository.Table.Item>(_ database: Repository.Database,
                                                         column: String = "*",
                                                         addQuery: String = "",
                                                         arguments: [Any] = []) -> Result<T, Repository.ErrorCode> {
            let query = "SELECT \(column) FROM \(tableName)\(addQuery == "" ? "" : " \(addQuery)");"
            let result = Repository.Action.select(database, query: query, arguments: arguments)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                resultSet.result.next()
                guard let item = itemType.object(itemType, resultSet: resultSet) as? T else {
                    fatalError("[FMDB ERROR] object pasing")
                }
                return .success(item)
            } else {
                fatalError()
            }
        }

        open class func objectResultSet(_ database: Repository.Database, 
                                        column: String = "*",
                                        addQuery: String = "",
                                        arguments: [Any] = []) -> Result<FMResultSet, Repository.ErrorCode> {
            let query = "SELECT \(column) FROM \(tableName)\(addQuery == "" ? "" : " \(addQuery)");"
            let result = Repository.Action.select(database, query: query, arguments: arguments)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                return .success(resultSet.result)
            } else {
                fatalError()
            }
        }

        open class func insert(_ database: Repository.Database, 
                               columnsQuery: String,
                               values: [Any]) -> Result<Void, Repository.ErrorCode> {
            let query = "INSERT INTO \(tableName) (\(columnsQuery)) VALUES (\(values.map { _ in "?" }.joined(separator: ",")));"
            let result = Repository.Action.insert(database, query: query, arguments: values)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                return .success(())
            } else {
                fatalError()
            }
        }

        open class func insert(_ database: Repository.Database,
                               columnsQuery: String,
                               valuesList: [[Any]]) -> Result<Void, Repository.ErrorCode> {
            let valuesQuery = valuesList.map { "(\($0.map { _ in "?" }.joined(separator: ",")))" }.joined(separator: ",")
            let arguments = valuesList.flatMap { $0 }
            let query = "INSERT INTO \(tableName) (\(columnsQuery)) VALUES \(valuesQuery);"
            let result = Repository.Action.insert(database, query: query, arguments: arguments)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case let .success(resultSet) = result {
                return .success(())
            } else {
                fatalError()
            }
        }

        open class func delete(_ database: Repository.Database, 
                               addQuery: String = "",
                               arguments: [Any] = []) -> Result<Void, Repository.ErrorCode> {
            let query = "DELETE FROM \(tableName)\(addQuery == "" ? "" : " \(addQuery)");"
            let result = Repository.Action.delete(database, query: query, arguments: arguments)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case .success = result {
                return .success(())
            } else {
                fatalError()
            }
        }

        open class func delete(_ database: Repository.Database, 
                               column: String,
                               value: Any) -> Result<Void, Repository.ErrorCode> {
            let query = "DELETE FROM \(tableName) WHERE \(column) = ?;"
            let result = Repository.Action.delete(database, query: query, arguments: [value])
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case .success = result {
                return .success(())
            } else {
                fatalError()
            }
        }

        open class func delete(_ database: Repository.Database, 
                               column: String,
                               values: [Any]) -> Result<Void, Repository.ErrorCode> {
            let deleteIn = values.map { _ in "?" }.joined(separator: ",")
            let query = "DELETE FROM \(tableName) WHERE \(column) IN (\(deleteIn));"
            let result = Repository.Action.delete(database, query: query, arguments: values)
            if case let .failure(errorCode) = result {
                return .failure(errorCode)
            } else if case .success = result {
                return .success(())
            } else {
                fatalError()
            }
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
            type.init(resultSet)
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
