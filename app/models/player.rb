class Player

  attr_accessor :name, :cards, :num_cards, :num_cards_remaining, :num_battles, :num_wars, :num_wars_won, :num_battles_won, :current_state, :time_at_table, :anxiety_level, :quickness

  def initialize n=''
    @name = n
    @num_cards, @num_cards_remaining = 0, 0
    @num_battles, @num_battles_won, @num_wars, @num_wars_won = 0,0,0,0
    @cards = []
  end

  def gain_cards c=[]
    @cards.push(c)
    @num_cards_remaining += c.count
  end

  def lose_cards c=[]
    @cards = @cards.keep_if{|x| !c.include? x}
    @num_cards_remaining -= c.count
  end

  def lost_battle
    @num_battles += 1
  end

  def won_battle
    @num_battles += 1
    @num_battles_won += 1
  end
  
  def lost_war
    @num_wars += 1
  end

  def won_war
    @num_wars += 1
    @num_wars_won += 1
  end
end