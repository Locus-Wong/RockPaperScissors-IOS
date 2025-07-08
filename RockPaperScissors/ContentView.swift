//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Locus Wong on 2025-07-07.
//

import SwiftUI

struct ContentView: View {
    let choices = ["Rock", "Paper", "Scissors"]
    let choiceIcons = ["mountain.2.fill", "doc.fill", "scissors"]
    let choiceEmojis = ["🗿", "📄", "✂️"]
    
    @State private var appChoice = Int.random(in: 0...2)
    @State private var userChoice: Int?
    @State private var shouldWin = Bool.random()
    @State private var currentScore: Int = 0
    @State private var currentRound: Int = 1
    @State private var gameOver = false
    @State private var showingResult = false
    @State private var lastRoundCorrect = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                // Header Section
                VStack(spacing: 10) {
                    Text("Round \(currentRound) of 10")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Score: \(currentScore)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(currentScore >= 0 ? .green : .red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
                // Game Status Section
                VStack(spacing: 15) {
                    Text("Opponent chose:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 10) {
                        Text(choiceEmojis[appChoice])
                            .font(.system(size: 60))
                        Text(choices[appChoice])
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                    
                    Text(shouldWin ? "You should WIN!" : "You should LOSE!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(shouldWin ? .green : .red)
                        .padding()
                        .background(shouldWin ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // Choice Buttons Section
                VStack(spacing: 15) {
                    Text("Make your choice:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            Button(action: {
                                userChoice = index
                                calculateScore()
                            }) {
                                VStack(spacing: 8) {
                                    Text(choiceEmojis[index])
                                        .font(.system(size: 40))
                                    Text(choices[index])
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(radius: 3)
                            }
                            .disabled(gameOver)
                        }
                    }
                }
                
                // Result feedback (shows after each round)
                if showingResult {
                    Text(lastRoundCorrect ? "Correct! +1 point" : "Wrong! -1 point")
                        .font(.headline)
                        .foregroundColor(lastRoundCorrect ? .green : .red)
                        .padding()
                        .background(lastRoundCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .cornerRadius(10)
                        .transition(.opacity)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Rock Paper Scissors")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Game Over!", isPresented: $gameOver) {
                Button("Play Again") {
                    resetGame()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(getFinalMessage())
            }
        }
    }
    
    func nextRound() {
        shouldWin = Bool.random()
        appChoice = Int.random(in: 0...2)
        
        // Hide result feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showingResult = false
        }
    }
    
    func calculateScore() {
        guard let userChoice = userChoice else { return }
        
        // Check if user naturally wins (Rock beats Scissors, Paper beats Rock, Scissors beats Paper)
        let userWins = (userChoice - appChoice == 1 || userChoice - appChoice == -2)
        
        // Check if user naturally loses
        let userLoses = (userChoice - appChoice == -1 || userChoice - appChoice == 2)
        
        // Award points based on what they were supposed to do
        let correctChoice = (userWins && shouldWin) || (userLoses && !shouldWin)
        
        if correctChoice {
            currentScore += 1
            lastRoundCorrect = true
        } else {
            currentScore -= 1
            lastRoundCorrect = false
        }
        
        // Show result feedback
        showingResult = true
        
        currentRound += 1
        
        if currentRound <= 10 {
            nextRound()
        } else {
            // Game over
            gameOver = true
        }
    }
    
    func resetGame() {
        currentRound = 1
        currentScore = 0
        gameOver = false
        showingResult = false
        shouldWin = Bool.random()
        appChoice = Int.random(in: 0...2)
        userChoice = nil
    }
    
    func getFinalMessage() -> String {
        let percentage = Double(currentScore) / 10.0 * 100
        switch currentScore {
        case 8...10:
            return "Excellent! You scored \(currentScore)/10 (\(Int(percentage))%)"
        case 5...7:
            return "Good job! You scored \(currentScore)/10 (\(Int(percentage))%)"
        case 2...4:
            return "Not bad! You scored \(currentScore)/10 (\(Int(percentage))%)"
        default:
            return "Keep practicing! You scored \(currentScore)/10 (\(Int(percentage))%)"
        }
    }
}

#Preview {
    ContentView()
}
