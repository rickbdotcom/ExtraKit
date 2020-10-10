//
//  ArraySection.swift
//  ExclusiveResorts
//
//  Created by rickb on 4/1/18
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation

extension Sequence {

    func sections<Section>(sameSection: (Element, Element) -> Bool, newSection: ([Element]) -> Section, sort: ((Element, Element) -> Bool)? = nil) -> [Section] {
        var sections = [Section]()

        let array = sort.flatMap { sorted(by: $0) } ?? Array(self)
        if var prevItem = array.first {
            var items = [Element]()

            array.forEach { item in
                if sameSection(item, prevItem) == false {
                    sections.append(newSection(items))

                    prevItem = item
                    items = [Element]()
                }
                items.append(item)
            }
            sections.append(newSection(items))
        }
        return sections
    }
}
