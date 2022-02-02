class Game
  def initialize()
    @chosenWord = nil
	@guessCount = 0
	@prevLetters = ['a', 'e', 'i', 'o', 'u']
  end

  # looks through the word dictionary and selects
  # a random word for the player to guess
  def getRandWord()
    file = File.open("word_dictionary.txt", "r")
    wordSelection = rand(0..file.count)
	file.rewind
    fileLineCount = 0
	while !file.eof?
	  line = file.readline
	  if fileLineCount == wordSelection
	    @chosenWord = line
	  end
	  fileLineCount += 1
	end
  end

  # displays blanks along with any correctly
  # guessed letters belonging to the chosen word
  def displayWord()
    @chosenWord.each_char do |letter|
	  if !@prevLetters.include?(letter)
	    print "_"
	  else
	    print letter
	  end
	end
	print "\n"
  end
end


g = Game.new()

g.getRandWord()
g.displayWord()
