//
//  ContentView.swift
//  OptinalChildStateProblem
//
//  Created by Cihan Kisakurek on 21.11.22.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<AppDomain>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Button {
                    viewStore.send(.show)
                } label: {
                    Text("Show")
                }

            }
            .padding()
            .fullScreenCover(
                item: viewStore.binding(
                    get: \.optionalDomain,
                    send: AppDomain.Action.updateOptionalDomain
                )
            ) { _ in
                let createStore = store.scope(
                    state: \.optionalDomain,
                    action: AppDomain.Action.optionalDomainAction
                )
                IfLetStore(createStore) { store in
                    CoverViewWithTextInput(store: store)
                }
            }
        }
        
    }
}


struct CoverViewWithTextInput: View {
    let store: StoreOf<OptionalDomain>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextField("Text", text: viewStore.binding(\.$input))
                    .textFieldStyle(.roundedBorder)
                Button {
                    viewStore.send(.close)
                } label: {
                    Text("Close")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}


struct AppDomain: ReducerProtocol {
    struct State: Equatable {
        var optionalDomain: OptionalDomain.State?
    }
    
    enum Action: Equatable {
        case show
        case updateOptionalDomain(OptionalDomain.State?)
        case optionalDomainAction(OptionalDomain.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .show:
                state.optionalDomain = OptionalDomain.State()
                return .none
            case .optionalDomainAction(.close):
                state.optionalDomain = nil
                return .none
            case .optionalDomainAction(.binding(_)):
                return .none
            case .updateOptionalDomain(let newState):
                state.optionalDomain = newState
                return .none
            }
        }
        .ifLet(\.optionalDomain, action: /AppDomain.Action.optionalDomainAction) {
            OptionalDomain()
        }
    }
}



struct OptionalDomain: ReducerProtocol {
    struct State: Equatable, Identifiable {
        @BindableState var input: String = ""
        var id = UUID()
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case close
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .close:
                return .none
            case .binding(_):
                return .none
            }
        }
    }    
}
