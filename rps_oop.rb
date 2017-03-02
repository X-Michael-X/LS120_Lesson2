require 'pry'

class RPSGame
  attr_reader :record, :human_choices
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_score = 0
    @computer_score = 0
    @record = []
    @human_choices = []
  end
  
  def clear_screen
    system('clear') || system('cls')
  end

  def display_welcome_message
    puts "Welcome #{human.name}!"
  end

  def display_goodbye_message
    puts "Goodbye!"
  end

  def display_choices
    puts "#{human.name} chose : #{human.move}."
    puts "#{computer.name} chose : #{computer.move}."
    record << [human.name, human.move, computer.name, computer.move]
  end

  def display_winner
    if human.move > computer.move
      human_choices << (human.move).to_s
      human.increase_score
      puts "#{human.name} Won the Round! You have #{human.score} points."
    elsif computer.move > human.move
      computer.increase_score
      puts "#{computer.name} Won the Round! They have #{computer.score} points."
    else
      puts "It's a Tie!"
    end
  end
  
  def display_record
    puts "Would you like to see the match record (y/n)?"
    choice = gets.chomp.downcase
    return unless choice == 'y'
    record.each_with_index do |round, index|
      puts "Round #{index + 1}: #{human.name} chose #{record[index][1]}, " \
           "#{computer.name} chose #{record[index][3]}."
    end
  end

  def play_again
    choice = nil
    loop do
      puts "Would you like to play again (y/n)?"
      choice = gets.chomp.downcase
      clear_screen
      break if ['y', 'n'].include? choice
      puts "Invalid Answer."
  end

    return if choice == 'n'
    human.choose
    if human.score - computer.score >= 2
      computer.adapt
    else
      computer.choose
    end
    display_choices
    display_winner
    display_record
    return if game_over?
    play_again
  end

  def game_over?
    if human.score == 10
      return "#{human.name} earned 10 points first! You Won the Game!"
    elsif computer.score == 10
      return "#{computer.name} earned 10 points first! They Won the Game!"
    end
  end

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_choices
    display_winner
    play_again
    display_goodbye_message
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    ((rock? || spock?) && other_move.scissors?) ||
      ((scissors? || lizard?) && other_move.paper?) ||
      ((paper? || spock?) && other_move.rock?) ||
      ((scissors? || rock?) && other_move.lizard?) ||
      ((lizard? || paper?) && other_move.spock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def increase_score
    self.score += 1
  end
end

class Human < Player
  
  def initialize
    set_name
    self.score = 0
  end

  def set_name
    n = ''
    loop do
      puts 'What is your name?'
      n = gets.chomp
      break unless n.empty?
      puts 'Sorry, you must enter a name.'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "#{self.name}, please choose Rock, Paper, Scissors, Lizard, or Spock"
      choice = gets.chomp.downcase
      display_record if choice == 'record'
      break if Move::VALUES.include? choice
      puts 'Incorrect input.'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  
  def initialize
    set_name
    self.score = 0
  end

  def set_name
    self.name = ['Johnny 5', 'HAL', 'R2D2', 'BB-8', 'Deep Blue'].sample
  end

  def choose
    if name == ('Johnny 5' || 'Deep Blue')
      self.move = Move.new(Move::VALUES[0])
    elsif name == ('HAL' || 'BB-8')
      result = (1..10).to_a.sample
      self.move = if (1..7).cover?(result)
                    Move.new(Move::VALUES[2])
                  else
                    Move.new(Move::VALUES.sample)
                  end
    else
      self.move = Move.new(Move::VALUES.sample)
    end
  end
  
  def adapt
    self.move = Move.new(Move::VALUES.sample)
  end  
end

RPSGame.new.play

