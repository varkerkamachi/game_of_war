class Game
  # include GameConfig
  include CardFuncs

  attr_accessor :num_cards_per_war, :num_players, :players, :deal_order, :state, :duration, :num_wars, :num_battles, :state, :winner, :winning_player, :hand_played, :cards_on_table, :war_is_on

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
    'Quincey',
    'Stasia',
    'Tricia',
    'Wayne',
    'Zaya'
  ]

  def initialize num_cards_per_war=1, num_players=2, players = []
    @num_players = num_players
    @players = []
    @players = players.blank? ? get_players : players
    @state = 'stop'
    @deal_order = 'clockwise'
    @num_cards_per_war = num_cards_per_war

    @winner = false
  end

  # sets up some of the default values & accessors for the game
  def start_game
    set_game_state 'play'
    @deck = Deck.new
    @deck.shuffle
    @deck.deal @players
    @hand_played = []
    @cards_on_table = []
    @war_is_on = false
    nil
  end

  # controls logic for each turn of play - must be called after each successful battle or war completion
  def play_turn
    reset_hand
    @winning_player = nil
    unless is_game_over?
      all_play_a_card
      score_battle @hand_played
    else
      end_game
    end
  end

  # players place cards in tmp array 'hand_played', also shift from their cards array into game-persisted array 'cards_on_table'
  def all_play_a_card
    @players.each do |p|
      @hand_played << p.try(:cards).try(:first) if p.has_cards?
      @cards_on_table << p.try(:cards).try(:shift) if p.has_cards?
    end
  end

  # allows a player to leave the game when they have run out of cards
  def player_leaves_game p
    players.each{|x| players.delete(x) if x === p}
    puts "Player left game: #{p.try(:name)}"
  end

  def score_battle cards_played
    # decide which of the cards on the table is the highest rank
    @hand_played = rank_cards_played(cards_played)
    # check if there was a tie .... since they're already ranked, compare the first two array elms
    tied = (@hand_played[0].try(:face_value) == @hand_played[1].try(:face_value)) if @hand_played
    if tied # go to war
      display_battle_results
      go_to_war
    else
      winner_take_hand
    end
    players.each{ |p| p.update_card_owner }
    nil
  end

  # called when there is a tie in #score_battle
  def go_to_war
    # for use in battle/war results
    set_game_state 'war'
    # clear previous hand..
    reset_hand
    @num_cards_per_war.times do |w|
      all_play_a_card
    end
    # clear previous hand also, as it's the face-down card or cards
    reset_hand

    # populate hand_played array again
    all_play_a_card
    # score it...
    score_battle @hand_played

    # after scoring, update war metadata for players 
    @winning_player.won_war
    players.each{|x| x.in_war }
    nil
  end

  # toggles game state between 'stop', 'play', 'war'...could be others
  def set_game_state s=''
    @state = s
  end

  # should convert owner of all cards to the name of the player with highest scoring card
  # also increment their num_cards_remaining attr and decrement remaining players
  def winner_take_hand
    from_war = @state == 'war'

    #save this for use in the stats display later
    @hand_played.freeze 

    @winning_player = get_player_by_name @hand_played.try(:first).try(:owner)
    # @hand_played.each{|x| cards_played.push(x)}

    unless @winning_player.blank?      
      # first calculate the loser's lost cards and metadata
      @cards_on_table.each do |c|
        get_player_by_name( c.try(:owner) ).in_battle
        get_player_by_name( c.try(:owner) ).lose_cards [c]
      end

      # winner puts all cards on table at the end of their deck, change ownership
      @winning_player.gain_cards(@cards_on_table)
      @winning_player.won_battle

      # reset var to empty array
      @cards_on_table = []
    end

    # check if all players can continue
    players.each do |p|
      player_leaves_game(p) if p.try(:cards).try(:count) < 1
    end

    display_battle_results
    set_game_state 'play'
  end

  # check if any of the players contain all the cards...or the state has been artificially set (if we want to exit early)..or... decorator?
  def is_game_over?
    players.count < 2 ||
      @state == 'stop' ||
        @cards_on_table.count >= Deck.num_cards ||
          (players.map{|p| p.num_cards_remaining == Deck.num_cards}.include? true)
  end

  # can be called from controller directly to end the game early if we don't wish to wait...
  def end_game
    @state = 'stop'
    @winner = true
    get_winning_player
    puts "================        =====================      ==================="
    puts "-------------------- GAME OVER! ______________________________________"
    puts "____________________WINNER: #{get_winning_player.try(:name)} --------------------------"
    puts "================        =====================      ==================="
    # write stats/scores to dB ...
  end

  # called after end of game for statistical purposes - overall game-winner
  def get_winning_player
    # if one player has all the cards
    players.map{|p| @winning_player = p if p.num_cards_remaining == Deck.num_cards}

    # if that's not the case, take the player with the highest number of cards
    if @winning_player.blank?
      @winning_player = CardFuncs::player_with_highest_card_count players
    end
    @winning_player
  end

  # utility method to find a player by name
  def get_player_by_name n
    @players.each{|p| return p if p.try(:name).try(:downcase) == n.try(:downcase) }
  end

  # simple CLI display of results from wars and battles
  # additional stats can be displayed by iterating through the game's players with the #stats method,
  # like so: `players.each{|p| p.stats}`
  def display_battle_results
    # Used to determine if it was a regular single battle, or an ongoing war...
    from_war = @state == 'war'

    puts "## -----------------------------------------------"
    puts "Hand: "
    @hand_played.each do |card|
      puts "#{card.try(:owner).try(:titleize)} played the #{card.try(:face_value)} of #{card.try(:suit)}"
    end

    if @winning_player
      if from_war # this is only after a tie has ocurred and another hand has been played
        puts "-=-=-=-=-=-=-=-= War won by #{@winning_player.try(:name).try(:titleize)} -----------"
      else
        # this can be after a single hand and there is a clear winner, or after a hand in which there is a tie
        puts "-=-=-=-=-=-=-=-= Battle won by #{@winning_player.try(:name).try(:titleize)} -----------"
      end

      puts "Status: "
      players.sort{|a,b| b.num_cards_remaining <=> a.num_cards_remaining}.each do |player|
        puts "#{player.try(:name)} has #{player.try(:num_cards_remaining)} cards left!"
        # puts "#{player.try(:name)} will play the #{player.try(:cards).try(:first).try(:face_value)} of #{player.try(:cards).try(:first).try(:suit)} next!"
      end
      @hand_played.each do |c|
        # face cards or higher...
        if (c.try(:face_value).try(:to_i) == 0) && (c.try(:owner) != @winning_player.name)
          puts "!!!***!!!*** Ouch! #{c.try(:owner)} lost #{c.try(:face_value) == 'A' ? 'an' : 'a'} #{c.try(:face_value)}!! "
        end
      end
      puts "#{@winning_player.try(:name).try(:titleize)} has won #{@winning_player.num_battles_won} battles and #{@winning_player.num_wars_won} wars "
    else
      if from_war # this is only after a tie has ocurred and another hand has been played
        puts "No winner of the war yet  -----------"
      else
        # this can be after a single hand and there is a clear winner, or after a hand in which there is a tie
        puts "Battle not won ... we're going to war! -----------"
        # increment player stats
        players.each{ |p| p.try(:in_battle) }
      end

    end
    puts "## -----------------------------------------------"
  end

  protected
  # set hand_played var back to an empty array for the next turn
  def reset_hand
    @hand_played = []
  end

  # should render a player name + last name initial
  def select_player
    Player.new( [PLAYER_NAMES.try(:shuffle).try(:first), ('A'..'Z').try(:to_a).try(:sample).concat('.')].join(' ') )
  end

  def get_players
    @num_players.try(:to_i).times do |p|
      gp = select_player
      if @players.map{|player| player.name}.include? gp.try(:name)
        gp = select_player
      end
      @players.push( gp )
    end
    @players
  end


end


# ---------------
# FLOW
# game -
# select players
# shuffle deck
# deal
# begin play....
# turn --
  # battle, battle... war...
# check outcome
# one player loses all cards
# game over