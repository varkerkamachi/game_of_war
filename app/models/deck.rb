class Deck
  attr_accessor :shuffled, :num_cards, :dealt, :cards, :available_cards
  include CardFuncs

  def initialize
    @cards = []
    Card::SUITS.each do |s|
      Card::VALUES.each do |v|
        @cards.push( Card.new(s, v) )
      end
    end
    @shuffled = false
    @dealt = false
    @num_cards = 52
    @available_cards = 52
  end

  def shuffle
    @shuffled = true
    @cards = @cards.shuffle
  end

  # give cards to each player... by assigning owner attribute
  def deal players=[]
    return false if players.blank? || !@shuffled
    split_count = (@cards.count/players.count).to_i

    players.each_with_index do |player, pidx|
      (pidx..@cards.count-1).step(players.count) do |c|
        # assign owner attribute of card instance
        @cards[c].owner = player.try(:name)

        # increase player's num_card & remaining attribute counts
        player.num_cards += 1
        player.num_cards_remaining += 1

        # add card to player's cards array
        player.cards.push(@cards[c])
      end
    end

    # puts "dealt: #{calculate_dealt_cards @cards.count} ..........."
    # set dealt property to true
    @dealt = true
  end

  class << self
    def num_cards
      52
    end
  end

end