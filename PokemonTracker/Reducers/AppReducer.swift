//
//  AppReducer.swift
//  PokemonTracker
//
//  Created by Gabriel Marson on 29/07/19.
//  Copyright © 2019 Gabriel M. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    print("App reducer called")
    return AppState(routingState: routingReducer(action: action, state: state?.routingState),
                    searchState: searchReducer(action: action, state: state?.searchState),
                    savedState: savedReducer(action: action, state: state?.savedState),
                    detailState: detailReducer(action: action, state: state?.detailState))
}
