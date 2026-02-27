import Foundation

// GameMode.swift
enum GameMode {
    case watch, predict, sort
}

enum MoveType {
    case swapLeft, stay, swapRight // Corresponds to Low, Mid, High actions
}
