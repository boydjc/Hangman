class Game
  def initialize()
    @chosenWord = ""
	@guessCount = 0
	@maxGuesses = 5
	@prevLetters = ['a', 'e', 'i', 'o', 'u']
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
	        @chosenWord = line
		  end
	    end
	    fileLineCount += 1
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
	  if !@prevLetters.include?(letter)
	    print " _"
	  else
	    print " #{letter}"
	  end
	end
	print "\n"
  end
end


g = Game.new()

g.getRandWord()
g.displayWord()
