require 'colorize'
class PlayingCard
  attr_reader :suit, :rank
  attr_accessor :deck

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def face_card?
   ['J', 'Q', 'K'].include?(@rank)
  end
end

SUITS = ['♣︎', '♦︎', '♥︎', '♠︎']
VALUES = [2, 3, 4, 5, 6, 7, 8, 9, '10', 'J', 'Q', 'K', 'A']

class Deck
  attr_reader :deck, :card
  def initialize
    @deck = []
    SUITS.each do |suit|
      VALUES.each do |value|
        @deck << PlayingCard.new(suit, value)
      end
    end
  end

  def card
    @card = @deck.shuffle.pop
  end
end

class Hand
  attr_reader :deck
  attr_accessor :score, :counter, :standing
  def initialize
    @deck = Deck.new
    @hands_in_play = [ [], [] ]
    @counter = 0
    @standing = [0,0]
  end

  def initial_hand
    @hands_in_play.each do |player|
      player <<  ("#{@deck.card.rank}#{@deck.card.suit}")
    end
  end

  def update_players_hand
    @hands_in_play[counter] <<  ("#{@deck.card.rank}#{@deck.card.suit}")
  end

  def score
    @score = 0
    @hands_in_play[counter].each do |card|
    if card[0] == "J" || card[0] == "Q" || card[0] == "K" || card[1] == "0"
      @score += 10
    elsif card.include? "A"
      if @score > 10
        @score += 1
      else
        @score += 11
      end
    else
      @score += card[0].to_i
    end
    end
  @score
  end

  def game
    answer = ""
    player = "Player"
    until counter == 2
      puts "#{player} was dealt #{@hands_in_play[counter]}\n"
      puts "#{player}'s Score: #{score}"
      puts "Hit or stay (H/S)?"
      answer = gets.chomp
      if "#{score}".to_i <= 21
        if answer.downcase == 'h'
          update_players_hand
          if score > 21
            puts "#{player} was dealt #{@hands_in_play[counter][-1]}\n"
            puts "#{player}'s Score: #{score}"
            puts "Player loses."
            standing[1] = standing[1] + 1
            break
          end
        elsif answer.downcase == 's'
          if @counter == 0
            player_score = score
            @counter +=1
            player = "Dealer"
            until score > 16
              update_players_hand
            end
            puts "Dealer was dealt #{@hands_in_play[counter]}\n"
            puts "Dealer's Score: #{score}"
            if score > player_score && score < 22
              puts "Player loses."
              standing[1] = standing[1] + 1
            elsif score == player_score
              puts "Tie"
            else
              standing[0] = standing[0] + 1
              puts "\nDealer loses."
              puts ["HERE COMES THE MONAYYYYYYY!- Naughty By Nature", "ALL I DO IS WIN! - DJ Khaled", "Easiest Game of my Life. - Jojo Tessel"].sample.colorize(:green)
            end
            break
          end
        else
          puts "Incorrect input. Please choose either h/s"
          puts
        end
      end
    end
  end
end
score = [0,0]
a = true
until a == false
hand = Hand.new
print "Score: " + score.to_s
puts
2.times do hand.initial_hand end
puts hand.game
puts "Would you like to play again? (y/n)"
a = gets.chomp
if a.downcase == "y"
  a = true
elsif a.downcase == "n"
  a = false
else
  puts "I'LL TAKE THAT AS A YES! LET'S GO GAMBLE, BAY-BEE!"
end
puts
score[0] +=  hand.standing[0]
score[1] +=  hand.standing[1]
end
