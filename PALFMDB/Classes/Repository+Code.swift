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

// Repository + Code
extension Repository {
    public enum SuccessCode {
        case `default`(Database, String)
        case rowid(Database, String, Int)
        case count(Database, String, Int)
        case object(Database, String, Repository.Table.Item?)
        case list(Database, String, [Repository.Table.Item])
        case update(Database, String)
        case insert(Database, String)
        case delete(Database, String)

        public var query: String {
            switch self {
            case .`default`(_, let query):
                return query
            case .rowid(_, let query, _):
                return query
            case .count(_, let query, _):
                return query
            case .object(_, let query, _):
                return query
            case .list(_, let query, _):
                return query
            case .update(_, let query):
                return query
            case .insert(_, let query):
                return query
            case .delete(_, let query):
                return query
            }
        }

        public var database: Database {
            switch self {
            case .`default`(let database, _):
                return database
            case .rowid(let database, _, _):
                return database
            case .count(let database, _, _):
                return database
            case .object(let database, _, _):
                return database
            case .list(let database, _, _):
                return database
            case .update(let database, _):
                return database
            case .insert(let database, _):
                return database
            case .delete(let database, _):
                return database
            }
        }

        public var errorMessage: String {
            return self.database.lastErrorMessage()
        }

        public var rowid: Int {
            switch self {
            case .rowid(_, _, let rowid):
                return rowid
            default:
                return 0
            }
        }

        public var count: Int {
            switch self {
            case .count(_, _, let count):
                return count
            default:
                return 0
            }
        }

        public var object: Repository.Table.Item? {
            switch self {
            case .object(_, _, let object):
                return object
            default:
                return nil
            }
        }

        public var list: [Repository.Table.Item] {
            switch self {
            case .list(_, _, let list):
                return list
            default:
                return []
            }
        }
    }

    public enum ErrorCode: Error {
        case open(Database, String, String)
        case createIfExistTable(Database, String, String)
        case dropTable(Database, String, String)
        case alertIfExistsTable(Database, String, String)
        case insert(Database, String, String)
        case select(Database, String, String)
        case update(Database, String, String)
        case delete(Database, String, String)

        public var query: String {
            switch self {
            case .open(_, _, let query):
                return query
            case .createIfExistTable(_, _, let query):
                return query
            case .dropTable(_, _, let query):
                return query
            case .alertIfExistsTable(_, _, let query):
                return query
            case .insert(_, _, let query):
                return query
            case .select(_, _, let query):
                return query
            case .update(_, _, let query):
                return query
            case .delete(_, _, let query):
                return query
            }
        }

        public var database: Database {
            switch self {
            case .open(let database, _, _):
                return database
            case .createIfExistTable(let database, _, _):
                return database
            case .dropTable(let database, _, _):
                return database
            case .alertIfExistsTable(let database, _, _):
                return database
            case .insert(let database, _, _):
                return database
            case .select(let database, _, _):
                return database
            case .update(let database, _, _):
                return database
            case .delete(let database, _, _):
                return database
            }
        }

        public var errorMessage: String {
            return self.database.lastErrorMessage()
        }
    }
}
