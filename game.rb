require 'yaml'

class Game
  def initialize()
    @chosenWord = ""
	@guessCount = 0
	@maxGuesses = 12
	@prevLetters = []
	@correctLetters = []
	@gameOver = false
  end

  public
  def self.deserialize(yaml_string)
    YAML.unsafe_load(yaml_string)
  end

# main game loop
  def startGame()
    getRandWord()
    while !@gameOver
	  checkForWin()
	  displayWord()
	  if !@gameOver
	    userLetter = getUserLetter()
        checkLetter(userLetter)
	    clearScreen()
	  end
	end
  end

  private
  def serialize(file_name)
    success = false
    serialized = YAML.dump(self)
	if !File.exists?("./saves/#{file_name}")
	  newSave = File.open("./saves/#{file_name}.yaml", "w")
	  newSave.puts serialized
	  newSave.close
	  success = true
	else
	  puts "That save file already exists. Please use another name."
	end
	return success
  end

  # looks through the word dictionary and selects
  # a random word for the player to guess
  def getRandWord()
    file = File.open("word_dictionary.txt", "r")
	while (@chosenWord == "")
	  file.rewind
      wordSelection = rand(0..file.count)
	  file.rewind
      fileLineCount = 0
	  while !file.eof?
	    line = file.readline
	    if fileLineCount == wordSelection
		  if line.length > 5 and line.length < 12
	        @chosenWord = line.strip
		  end
	    end
	    fileLineCount += 1
	  end
	end
  end

  # saves the game state with a given filename
  def saveGame()
    fileSaved = false
    while !fileSaved
      puts "Please enter your file save name"
      puts "Enter 'cancel' to cancel saving"
	  print ":"
	  fileName = gets().chomp()
	  fileName.downcase!
	  if fileName != 'cancel'
	    if File.exists?("./saves/#{fileName}.yaml")
		  clearScreen()
		  puts "Sorry. A save file with that name already exists."
		else
	      fileSaved = serialize(fileName)
	      puts "File Saved Successfully!"
		  @gameOver = true
		end
	  else
	    break
	  end
    end
  end

  # displays blanks along with any correctly
  # guessed letters belonging to the chosen word
  def displayWord()
    puts "You have #{@maxGuesses - @guessCount} guesses left."
	puts '-------------------------------------'
	puts "Letters guessed"
	p @prevLetters
	puts '-------------------------------------'
    @chosenWord.each_char do |letter|
	  if !@correctLetters.include?(letter)
	    print " _"
	  else
	    print " #{letter}"
	  end
	end
	print "\n"
  end

  def getUserLetter()
    userLetter = nil
	while userLetter == nil
      puts "Please enter one letter to guess"
	  puts "(Enter 'save' to save your game)"
	  print ":"
      potentialLetter = gets().chomp()
	  potentialLetter.downcase!
      if potentialLetter.match?(/[[:alpha:]]/) and 
	  !potentialLetter.match?(/[[:digit:]]/) and 
      !@prevLetters.include?(potentialLetter) and
	  potentialLetter.length == 1
	    @guessCount += 1
	    userLetter = potentialLetter
		@prevLetters.push(userLetter)
	  else
	    clearScreen()
		if potentialLetter == 'save'
		  userLetter = potentialLetter
          saveGame()
        else
		  if potentialLetter.match?(/[[:digit:]]/)
	        puts "Sorry. That is not valid input."
		  elsif @prevLetters.include?(potentialLetter)
		    puts "You have already guessed that letter."
		  elsif !potentialLetter.length == 1
		    puts "You can only input one letter"
		  end
		end
		displayWord()
	  end
	end
	return userLetter
  end

  # check if letter is in the chosen word 
  def checkLetter(letter)
    if @chosenWord.include?(letter)
	  @correctLetters.push(letter)
	end
  end

  # goes through each letter of the chosen
  # word and if a each letter has been guessed 
  # we have a win
  def checkForWin()
    win = true
	@chosenWord.each_char do |char|
	  if !@correctLetters.include?(char)
	    win = false
	  end
	end
	
	if win 
	  puts "You won!"
	  @gameOver = true
	elsif @guessCount >= @maxGuesses and !win
	  puts "Sorry. You have run out of guesses."
	  puts "The word was #{@chosenWord}"
	  @gameOver = true
	end
  end
end

# clears the console screen
def clearScreen()
  print "\e[2J\e[f"
end
