//
//  Handlers.swift

import Foundation

typealias actionHandler = (_ status: Bool, _ message: String) -> ()
typealias completionHandler = (_ status: Bool, _ code: Int, _ message: String) -> ()
typealias fileDownloadHandler = (_ status: Bool, _ message: String, _ url: String?) -> ()



