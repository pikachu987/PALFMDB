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

open class Repository {
    public static var tables: [Repository.Table.Type] = []
    public static var resourceName = (Bundle.main.infoDictionary?["CFBundleName"] as? String)?.components(separatedBy: ".").last?.appending(".db") ?? ""

    public static let `default` = Repository.Default()

    public static var database: Database {
        return Repository.default.database
    }
    
    public static var queue: DatabaseQueue? {
        return Repository.default.queue
    }

    @discardableResult
    public class func createIfExistsTable(_ database: Database) -> Result<SuccessCode, ErrorCode> {
        let query = self.tables.filter({ $0.createIfExistTableQuery != "" }).map({ $0.createIfExistTableQuery }).joined(separator: "")
        if query != "" {
            if !database.isOpen && !database.open() {
                return .failure(.open(database, query, database.lastErrorMessage()))
            }
            database.executeStatements(query)
            return .success(.default(database, query))
        } else {
            return .failure(.createIfExistTable(database, query, database.lastErrorMessage()))
        }
    }

    @discardableResult
    public class func dropTable(_ database: Database) -> Result<SuccessCode, ErrorCode> {
        let query = self.tables.filter({ $0.dropTableQuery != "" }).map({ $0.dropTableQuery }).joined(separator: "")
        if query != "" {
            if !database.isOpen && !database.open() {
                return .failure(.open(database, query, database.lastErrorMessage()))
            }
            database.executeStatements(query)
            return .success(.default(database, query))
        } else {
            return .failure(.dropTable(database, query, database.lastErrorMessage()))
        }
    }

    @discardableResult
    public class func alertIfExistsTable(_ database: Database) -> Result<SuccessCode, ErrorCode> {
        let query = self.tables.filter({ $0.alertIfExistsTableQuery != "" }).map({ $0.alertIfExistsTableQuery }).joined(separator: "")
        if query != "" {
            if !database.isOpen && !database.open() {
                return .failure(.open(database, query, database.lastErrorMessage()))
            }
            database.executeStatements(query)
            return .success(.default(database, query))
        } else {
            return .failure(.alertIfExistsTable(database, query, database.lastErrorMessage()))
        }
    }
    
    public class ResultSet {
        public var result: FMResultSet
        public init(_ result: FMResultSet) {
            self.result = result
        }
    }
}
