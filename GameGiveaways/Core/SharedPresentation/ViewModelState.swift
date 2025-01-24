//
//  ViewModelState.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//


enum ViewModelState<T> {
    case idle
    case loading
    case success(T)
    case failure(String)
}