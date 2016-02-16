module CardFuncs

  # hash of card face values equated to a point rank scale
  CARD_VALUES = {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    '10' => 10,
    '9' => 9,
    '8' => 8,
    '7' => 7,
    '6' => 6,
    '5' => 5,
    '4' => 4,
    '3' => 3,
    '2' => 2,
  }
  def calculate_dealt_cards deck_count
    Deck.num_cards - deck_count
  end

  # returns array of cards played, ranked in descending order
  def rank_cards_played cards
    return cards unless cards.is_a?(Array)
    cards = cards.sort{|a,b| CARD_VALUES[b.try(:face_value)] <=> CARD_VALUES[a.try(:face_value)]}
  end

  def player_with_highest_card_count players=[]
    players.sort{|a,b| b.num_cards_remaining <=> a.num_cards_remaining}.try(:first)
  end
end