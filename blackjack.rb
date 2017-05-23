require "pry"
require_relative 'player'
require_relative 'deck'

class BlackJack
  def initialize(player)
    @player = player
    @dealer_bank = []
    @deck = Deck.new
    welcome_blackjack
  end


  def welcome_blackjack
    puts "Welcome to black jack!!!!! Where the jack is black and Black Jack Black plays!!!"
    puts "How much do you want to bet?"
    bet = gets.to_f
    player_bet = @player.wallet.amount - bet
    @dealer_bank << bet
    blackjack_dealt_cards
  end

  def blackjack_dealt_cards
    face_values = { 'Ace' => 11, 'King' => 10, 'Jack' => 10, 'Queen' => 10 }
    @player_total = 0
    @dealer_total = 0

    player_first_card = @deck.cards.sample.rank
    player_second_card = @deck.cards.sample.rank
    binding.pry

    puts "You have #{player_first_card} #{@deck.cards.sample.suit}"
    if face_values.has_key? player_first_card
      player_first_card = face_values[player_first_card]
    end

    puts "and #{player_second_card} #{@deck.cards.sample.suit}."
    if face_values.has_key? player_second_card
      player_second_card = face_values[player_second_card]
    end

    dealer_first_card = @deck.cards.sample.rank

    puts "Dealer has #{dealer_first_card} #{@deck.cards.sample.suit}"
    if face_values.has_key? dealer_first_card
      dealer_first_card = face_values[dealer_first_card]
    end

    @player_total = player_first_card.to_i + player_second_card.to_i

    puts "Your total is #{player_total}"
    player_hit_stay

  end

  def player_hit_stay
    puts "Do you wanna 1) hit or 2) stay?"
    case gets.to_i
    when 1
      players_hit
    when 2
      dealer_hit
    else
      BlackJack.new
    end
  end

  def players_hit
    face_values = { 'Ace' => 11, 'King' => 10, 'Jack' => 10, 'Queen' => 10 }
    new_card = @deck.cards.sample.rank
    puts "#{new_card} #{@deck.cards.sample.suit}"
    if face_values.has_key? player_first_card
      new_card = face_values[new_card]
    end
    @player_total = @player_total + new_card.to_i

    if @player_total <= 21
      player_hit_stay
    elsif @player_total == 21
    else
      player_lose
    end
  end


  def dealer_hit
    face_values = { 'Ace' => 11, 'King' => 10, 'Jack' => 10, 'Queen' => 10 }
    dealer_second_card = @deck.cards.sample.rank
    puts "And dealer has #{dealer_second_card} #{@deck.cards.sample.suit}"
    if face_values.has_key? player_first_card
      new_card = face_values[new_card]
    end
    @dealer_total = @dealer_total + dealer_second_card.to_i
    puts "Dealer has #{@dealer_total}"

    if @dealer_total > @player_total
      player_lose
    elsif @dealer_total > 21
      player_win
    elsif @player_total == 21 && @dealer_total == 21
      player_dealer_tie
    end
  end

  def player_dealer_tie
    puts "You both got 21. Pot has been returned"
    @player.wallet.amount += @dealer_bank
  end

  def player_lose
    puts "YOU LOSE HARRY TWO NOSE!"
    casino_menu
  end

  def player_win
    puts "YOU WIN BOSS"
    @player.wallet.amount += (@dealer_bank.to_f * 1.5)
  end
end
