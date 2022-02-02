class Game
  def initialize()
    @chosenWord = nil
  end

  def getRandWord()
    file = File.open("word_dictionary.txt", "r")
    wordSelection = rand(0..file.count)
	file.rewind
    fileLineCount = 0
	puts file.eof?
	while !file.eof?
	  line = file.readline
	  if fileLineCount == wordSelection
	    @chosenWord = line
	  end
	  fileLineCount += 1
	end
  end

  def getChosenWord()
    puts "The chosen word is #{@chosenWord}"
  end
end


g = Game.new()

g.getRandWord()
g.getChosenWord()
