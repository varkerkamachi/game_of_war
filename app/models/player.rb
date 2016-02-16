class Player

  attr_accessor :name, :cards, :num_cards, :num_cards_remaining, :num_battles, :num_wars, :num_wars_won, :num_battles_won, :current_state, :time_at_table, :anxiety_level, :quickness

  def initialize n=''
    @name = n
    @num_cards, @num_cards_remaining = 0, 0
    @num_battles, @num_battles_won, @num_wars, @num_wars_won = 0,0,0,0
    @cards = []
  end

  def gain_cards c=[]
    # add other players' cards into my deck
    if c.is_a? Array
      # c.each{|card| card.owner = self.name }
      c.each{|card| @cards.push(card) }
    else
      @cards.push(c)
      # c.owner = self.name
    end
    # first card played has to go to back of deck
    # @cards = @cards.try(:rotate) -- deprecated , using shift in game model instead
    @num_cards_remaining += c.count
  end

  def update_card_owner
    @cards.each{ |x| x.owner = self.name }
  end

  # def change_owner
  #   return Proc.new{|c| c.owner = self.name}
  # end

  def lose_cards c=[]
    @cards = @cards.keep_if{|x| !c.include? x}
    @num_cards_remaining -= c.count
  end

  def in_battle
    @num_battles += 1
    nil
  end

  def won_battle
    @num_battles_won += 1
    nil
  end
  
  def in_war
    @num_wars += 1
    nil
  end

  def won_war
    @num_wars_won += 1
    nil
  end

  def has_cards?
    num_cards_remaining > 0
  end

  def stats
    puts "Name:  ------------------  #{name.try(:titleize)} -----------------"
    puts "----------------------------------   ----------------------------------"
    puts "Number of wars: #{num_wars}"
    puts "Number of wars won: #{num_wars_won}"
    puts "Number of battles: #{num_battles}"
    puts "Number of battles won: #{num_battles_won}"
    puts "Number of cards in hand: #{num_cards_remaining}"
    puts "----------------------------------   ----------------------------------"
    nil
  end
end