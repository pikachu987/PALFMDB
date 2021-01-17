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

// Repository + I S U D
extension Repository {
    open class Action {
        @discardableResult
        open class func insert(_ database: Database, query: String, arguments: [Any] = []) -> Result<Void, ErrorCode> {
            if !database.isOpen && !database.open() {
                return .failure(.open(database, query, database.lastErrorMessage()))
            }
            let result = database.executeUpdate(query, withArgumentsIn: arguments)
            if result {
                return .success(())
            } else {
                return .failure(.insert(database, query, database.lastErrorMessage()))
            }
        }

        @discardableResult
        open class func select(_ database: Database, query: String, arguments: [Any] = []) -> Result<Repository.ResultSet, ErrorCode> {
            if !database.isOpen && !database.open() {
                return .failure(.open(database, query, database.lastErrorMessage()))
            }
            guard let results = database.executeQuery(query, withArgumentsIn: arguments) else {
                return .failure(.select(database, query, database.lastErrorMessage()))
            }
            return .success(Repository.ResultSet(results))
        }

        @discardableResult
        open class func update(_ database: Database, query: String, arguments: [Any] = []) -> Result<Void, ErrorCode> {
            if !database.isOpen && !database.open() {
                return .failure(.open(database, query, database.lastErrorMessage()))
            }
            let result = database.executeUpdate(query, withArgumentsIn: arguments)
            if result {
                return .success(())
            } else {
                return .failure(.update(database, query, database.lastErrorMessage()))
            }
        }

        @discardableResult
        open class func delete(_ database: Database, query: String, arguments: [Any] = []) -> Result<Void, ErrorCode> {
            if !database.isOpen && !database.open() {
                return .failure(.open(database, query, database.lastErrorMessage()))
            }
            let result = database.executeUpdate(query, withArgumentsIn: arguments)
            if result {
                return .success(())
            } else {
                return .failure(.delete(database, query, database.lastErrorMessage()))
            }
        }
    }
}
