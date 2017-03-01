
class RPSGame
  attr_reader :record
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_score = 0
    @computer_score = 0
    @record = []
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
    record << ["#{human.name}/#{human.move} ,#{computer.name}/#{computer.move}"]
  end

  def display_winner
    if human.move > computer.move
      human.increase_score
      puts "#{human.name} Won the Round! You have #{human.score} points."
      if human.score == 3
        puts "#{human.name} earned 3 points first! You Won the Game!"
      end
    elsif computer.move > human.move
      computer.increase_score
      puts "#{computer.name} Won the Round! They have #{computer.score} points."
      if computer.score == 3
        puts "#{computer.name} earned 3 points first! They Won the Game!"
      end
    else
      puts "It's a Tie!"
    end
  end

  def display_record
    record.each_with_index do |_round, index|
      puts "Round #{index + 1}: #{human.name} chose #{human.move}, " \
           "#{computer.name} chose #{computer.move}"
    end
  end

  def play_again
    choice = nil
    loop do
      puts "Would you like to play again (Yes or No)?"
      choice = gets.chomp.downcase
      break if ['yes', 'no'].include? choice
      puts "Invalid Answer."
    end

    return if choice == 'no'
    human.choose
    computer.choose
    display_choices
    display_winner
    return if game_over?
    display_record
    play_again
  end

  def game_over?
    human.score == 3 || computer.score == 3
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
      puts "choose rock, paper, scissors, lizard, or Spock"
      choice = gets.chomp.downcase
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
    self.name = ['Johnny 5', 'HAL', 'R2D2'].sample
  end

  def choose
    if name == 'Johnny 5'
      self.move = Move.new(Move::VALUES[0])
    elsif name == 'HAL'
      result = (1..10).to_a.sample
      self.move = if (1..7).cover?(result)
                    Move.new(Move::VALUES[2])
                  else
                    Move.new(Move::VALUES[0])
                  end
    else
      self.move = Move.new(Move::VALUES.sample)
    end
  end
end

RPSGame.new.play
