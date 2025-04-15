//
//  HomeNavigation.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

protocol HomeNavigation : AnyObject {
    func showTransfer(cards : [CardModel])
    func returnHome()
}
