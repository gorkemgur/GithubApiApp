//
//  DateHelper.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

fileprivate enum DateFormatConstants {
    static let serverSideInputFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let clientSideOutputFormat = "dd-MM-yyyy"
}

final class DateHelper {
    static let sharedInstance = DateHelper()
    
    private init() { }
    
    func convertDate(from date: String) -> String {
        var formattedDate = "-"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = DateFormatConstants.serverSideInputFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = DateFormatConstants.clientSideOutputFormat
        
        if let convertedDate = inputFormatter.date(from: date) {
            formattedDate = outputFormatter.string(from: convertedDate)
        }
        
        return formattedDate
    }
}
