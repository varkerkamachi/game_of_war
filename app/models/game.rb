class Game
  # include GameConfig
  include CardFuncs

  attr_accessor :num_players, :players, :deal_order, :state, :duration, :num_wars, :num_battles

  PLAYER_NAMES = [
    'Adrian',
    'Amy',
    'Alexander',
    'Andrew',
    'Barbara',
    'Cary',
    'Cathy',
    'Castor',
    'Cristina',
    'Franklyn',
    'Hannah',
    'Moses',
    'Ned',
    'Patrick',
    'Quincy',
    'Stasia',
    'Tricia',
    'Wayne',
    'Zaya'
  ]

  def initialize num_players=2, players = []
    @num_players = num_players
    @players = []
    @players = players.blank? ? get_players : players
    @state = 'stop'
    @deal_order = 'clockwise'

    @winner = false
  end

  def start_game
    @state = 'play'
    @deck = Deck.new
    @deck.shuffle
    @deck.deal @players
  end

  def get_players
    @num_players.try(:to_i).times do |p|
      @players.push( Player.new(PLAYER_NAMES.try(:shuffle).try(:first)) )
    end
    @players
  end

  def play_turn
    cards_played = []
    @players.each do |p|
      cards_played << p.try(:cards).try(:first)
    end

    score_battle cards_played
  end

  def score_battle cards_played
    # decide which of the cards on the table is the highest rank
    cards_played = rank_cards_played cards_played
    puts "Crds played: #{cards_played.inspect}"
    # check if there was a tie .... 
    tied = cards_played.map{|x| x.face_value}.try(:uniq).try(:length) != cards_played.length

    if tied # go to war
      return false
      #war cards_played
    else
      puts "class: #{cards_played.class} .......... #{cards_played.inspect}"
      winner_take_hand cards_played
    end
  end

  # should convert owner of all cards to the name of the player with highest scoring card
  # also increment their num_cards_remaining attr and decrement remaining players
  def winner_take_hand cards_played
    winning_player = get_player_by_name cards_played.try(:first).try(:owner)
    puts "winning player: #{winning_player.inspect} ---------------:"
    unless winning_player.blank?
      # remove the first item from the array as the winner played the highest card, and so it's sorted, first item is the highest
      cards_played.shift

      winning_player.gain_cards(cards_played)
      winning_player.won_battle
      puts "c?-=-=--: #{cards_played.inspect} .......... "
      cards_played.each do |c|
      puts "p: #{get_player_by_name( c.try(:owner) ).inspect} .......... "
        get_player_by_name( c.try(:owner) ).lost_battle
        get_player_by_name( c.try(:owner) ).lose_cards [c]
      puts "p: #{get_player_by_name( c.try(:owner) ).inspect} .......... "

      end
    else
      return nil
    end
  end

  def get_player_by_name n
    @players.each{|p| return p if p.try(:name).try(:downcase) == n.try(:downcase) }
  end

end


# game -
# select players
# shuffle deck
# deal
# begin play
# battle, battle... war...
# one player loses all cards
# game over