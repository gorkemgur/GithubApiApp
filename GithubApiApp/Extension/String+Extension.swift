//
//  String+Extension.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

extension String {
    var convertDate: String {
        return DateHelper.sharedInstance.convertDate(from: self)
    }
}
