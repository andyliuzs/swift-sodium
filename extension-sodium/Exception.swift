//
//  Exception.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/21.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation
enum DataError : Error {
    case DataWrongformatError(String)
    case EmptyError(String)
}

