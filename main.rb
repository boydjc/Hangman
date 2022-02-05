require 'yaml'
require './game.rb'

def loadGame()
  saveFileName = nil
  while saveFileName == nil
    savedFileNames = Dir.glob("./saves/*.yaml")
	savedFileNames.map do |element|
	  element = element[8..]
	  element = element[0..element.length-6]
	  puts element
	end
    puts "Enter the name of a save file"
	print ":"
    potentialFileName = gets().chomp()
    if File.exists?("./saves/#{potentialFileName}.yaml")
      saveFileName = potentialFileName
      savedFile = File.open("./saves/#{saveFileName}.yaml")
	  game = Game.deserialize(savedFile)
	  savedFile.close
	  return game
	else
	  puts "Sorry. That save file does not exist."
    end
  end
end

def main()
  userChoice = nil
  while userChoice == nil
    puts "Welcome to Hangman!"
    puts "Would you like to create a new game or load from an existing file?"
    puts "1. New Game \t\t 2. Load Game"
    game = Game.new()
    userInput = gets().chomp()
    userInput = userInput.to_i
    if userInput == 1 or userInput == 2
      userChoice = userInput
      #clearScreen()
	  if userChoice == 2
	    game = loadGame()
      end
	  game.startGame()
	else
	  #clearScreen()
	  puts "Sorry. That input is not valid."
	end
  end
end

# clears the console screen
def clearScreen()
  print "\e[2J\e[f"
end

main()
