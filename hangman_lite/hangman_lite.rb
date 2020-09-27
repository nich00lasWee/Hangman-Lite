# Hangman Lite by 101214996

def difficulty

	puts "
Please select difficulty:
  [1] Easy
  [2] Medium
  [3] Hard
		"
	print "Your choice: "
	level = gets.chomp

	begin
		Integer(level) # Input must be integer
	rescue # If input is not numeric, user will have to input again
		puts "Please select between 1 to 3"
		difficulty
	else
		if (!((level.to_i >= 1) and (level.to_i <= 3)))
			puts "Please select between 1 to 3"
			difficulty
		else
			level = level.to_i
			case level
			when 1
				difficulty = "Easy"
			when 2
				difficulty = "Medium"
			else
				difficulty = "Hard"
			end
			puts "You selected: " + difficulty
		end	
	end
	
	level
	
end

def select_word (file)

	if (FileTest.exist?(file)) # check whether the text file exists
		words = Array.new
		lines = File.open(file,"r")
		words = lines.readlines # .readlines is used to read all data stored in the text file
		@words_1 = Array.new
		@words_2 = Array.new
			
		for i in 0..words.length - 1
			@hint1 = words[0]
			@hint2 = words[21]
			if ((i > 0) and (i < words.index(@hint2))) # .index to get index of @hint2 from words
				@words_1.push(words[i].chomp) # .chomp to remove trailing newlines
			elsif (i > words.index(@hint2)) 
				@words_2.push(words[i].chomp)								
			end
		end 
		
		selected_array = rand(0..1)
		index = rand(@words_1.length - 1) # randomly select an index from array of words
		
		if (selected_array == 0)
			gameword = @words_1[index]
		else 
			gameword = @words_2[index] # index can be used for both arrays since they have same size
		end		
		
		fopen = true	
	else
		fopen = false	
	end

	return gameword, fopen
	
end

def play

	puts "\nYou have #{@turns} turns left." 
	puts "Your word is #{@guess}"
	puts "\nType \"hint\" for hint"  # escape letter \"
	print "\nEnter a letter: " 
	letter = gets.chomp.downcase # input letter is transformed into small letter case
	
	if (letter == "hint")
		if (@words_1.include?(@gameword)) # if gameword is included in first word array
			hint = @hint1
		else
			hint = @hint2
		end
		puts "Hint: #{hint}"	
	elsif ((letter.length != 1) || (!/[a-z]/.match(letter))) # length validation & regular expression to check if the input is alphabet or not	
		puts "Invalid input" 
		play
	else
		if (@gameword.include?(letter)) # Checks if letter is in gameword
			for i in 0...@wordLength
				if ((@gameword[i] == letter) && (@guess[i] == "_"))
					@guess[i] = letter # If user entered a correct guess while the actual letter is unknown, the guess letter will replace the underscore
				elsif (@gameword[i] == letter)
					puts "You already used that letter"	
					play  
				end
			end
		elsif (@used_letters.include?(letter))
			puts "You already used that letter"
			puts "The incorrect letters you have used are: #{@used_letters}" 
		else 
			@turns -= 1
			@used_letters += letter.downcase << ","
			puts "\nThe incorrect letters you have used are: " << @used_letters
		end
	end
	
end

def save

	print "\nWould you like to save your score (y/n): "
	ans = gets.chomp.downcase
	
	while ((ans != "y") && (ans != "n"))
		puts "\nPlease enter either \"y\" or \"n\""
		print "Would you like to save your score (y/n): "
		ans = gets.chomp.downcase
	end
	
	if (ans == "y")
		print "\nPlease enter your name: "
		name = gets.chomp
		score_file = File.new("scores.txt","a") # opens text file to append in data without overwriting existing data
		score_file.puts("Player: #{name}\t --- Score: #{@score}\t --- Level: #{@stage}\n") # stores the user name, score and level chosen into text file
		score_file.close
	else
		print "\nPress enter to continue"
		gets
	end
	
end

def replay

	print "\nWould you like to start a new game (y/n): "
	ans = gets.chomp.downcase
		
	while ((ans != "y") && (ans != "n"))
		puts "\nPlease enter either \"y\" or \"n\""
		print "Would you like to start a new game (y/n): "
		ans = gets.chomp.downcase
	end
		
	if (ans == "y")
		main			
	else
		puts "\nThank you for playing\nPress enter to exit"
		gets
	end 
	
end

def main

	puts '
  _____________________________
  |                           |
  |  WELCOME TO HANGMAN LITE  |								 
  |___________________________| '
	level = difficulty
		
	if (level == 1)
		f = "dictionary/easy.txt"
		@stage = "Easy"
	elsif (level == 2)
		f = "dictionary/medium.txt"
		@stage = "Medium"
	else
		f = "dictionary/hard.txt"
		@stage = "Hard"
	end

	@gameword, fileExist = select_word(f)
	
	if (fileExist)
		@score = 0
		begin 
			@wordLength = @gameword.length
			@guess = ""
			@used_letters = ""
			@turns = 8

			for i in 0...@wordLength # same as 0..@wordLength - 1
				@guess = @guess << "_" # adds "_" to the end of @guess
			end

			while !((@turns == 0) or (@guess == @gameword))
				play
			end

			if (@turns > 0)
				@score += 1
				puts "\nCongratulations! You guessed the word correctly."		
				puts "The word is: #{@gameword}"
				puts "\nYour score is #{@score}."
				continue = true
				
				@gameword, fileExist = select_word(f)
				@wordLength = @gameword.length
			
				for i in 0...@wordLength
					@guess = @guess << "_" 
				end
			else
				puts "\nGame Over"	
				puts "The word is: #{@gameword}"
				save
				continue = false
			end
		
		end while (continue != false) # while the game is not over, the game continues
	else
		puts "Unable to locate text file."
		puts "Please check the directory: #{Dir.pwd}" #Shows the directory path
	end
		
	replay	# allows the user to start a new game or exit
	
end

main