#!/usr/bin/ruby
#CIT 383 - Project 2
#ASCII Minesweeper - written by Brendan Ryan

def pp_board (board)
	puts Array.new(board[0].size*2+1, '-').join('')
	board.each do |row|
		puts "|" + row.join('|') + "|"
		puts Array.new(row.size*2+1, '-').join('')
	end
end

def create_hint_board(board)

	@hint = Array.new(@row){Array.new(@col)}
	
	for i in 0..@row-1
		for j in 0..@col-1
			if board[i][j] == "*" then
				@hint[i][j] = board[i][j]
				adjValue(i,j)
			end 
		end
	end
	return @hint
end

def adjValue(mineRow, mineCol)

	for i in mineRow-1..mineRow+1
		for j in mineCol-1..mineCol+1
			if i == mineRow and j == mineCol then
				#skip
			elsif i < 0 or i >= @row or j < 0 or j >= @col then
				#skip
			else
				if @hint[i][j] == nil
					@hint[i][j] = 1
				else
					@hint[i][j] = @hint[i][j].to_i+1
				end
			end
		end
	end
	
end

def minefield()
	#open mines.txt file and remove first line
	mines = File.open("mines.txt")
	first_line = mines.gets
	
	@col = first_line[0].to_i 
	@row = first_line[2].to_i
	
	#initialize board array
	board = Array.new

	#read through each line of mines.txt
	mines.each_line do |line|
		#input line into board array
		board.push(line.chomp.split(//))
	end

	#close mines.txt 
	mines.close

	return board
end

def copy_to_blank(board)
	blank = Array.new
	for i in 0..(board.size-1)
		blank << Array.new(board[i].size, '.')
	end
	blank
end

def playGame(board)
	endGame = false

	until endGame == true
		puts "Enter a set of space separated coordinates, ex: 3 2. Enter q to give up"
		coordinates = gets.split(" ")
		if coordinates[0] == "q" then
			puts "Thank you for playing Minesweeper!"
			endGame = true
		else
			if @hint[coordinates[0].to_i-1][coordinates[1].to_i-1] == nil then
				board[coordinates[0].to_i-1][coordinates[1].to_i-1] = 0
			else
				board[coordinates[0].to_i-1][coordinates[1].to_i-1] = @hint[coordinates[0].to_i-1][coordinates[1].to_i-1]
			end
			pp_board(board)
			if board[coordinates[0].to_i-1][coordinates[1].to_i-1] == "*" then
				puts "GAME OVER!\n\n"
				puts "HINT"
				pp_board(@hintBoard)
				endGame = true
			end
		end
	end
end

board = minefield
@hintBoard = create_hint_board(board)
emptyBoard = copy_to_blank(board)
pp_board(emptyBoard)
playGame(emptyBoard)

