//
//  SearchState.swift
//  PokemonTracker
//
//  Created by Gabriel M on 7/29/19.
//  Copyright © 2019 Gabriel M. All rights reserved.
//

import ReSwift

struct SearchState: StateType {
    var navigationState: RoutingDestination
    
    init(navigationState: RoutingDestination = .search) {
        self.navigationState = navigationState
    }
}
