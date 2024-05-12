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
    public enum ErrorCode: Error {
        case open(Database, String, String)
        case createIfExistTable(Database, String, String)
        case dropTable(Database, String, String)
        case alterIfExistsTable(Database, String, String)
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
            case .alterIfExistsTable(_, _, let query):
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
            case .alterIfExistsTable(let database, _, _):
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
            database.lastErrorMessage()
        }
    }
}
