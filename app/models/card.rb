class Card

  attr_accessor :face_value, :suit, :owner

  # need concept of rank: AKQJ1098765432

  SUITS = %w{hearts spades diamonds clubs}
  VALUES = %w{A K Q J 10 9 8 7 6 5 4 3 2}

  def initialize suit='', face_value='', owner=nil
    @suit = suit
    @face_value = face_value
    @owner = owner
  end

  def is_suit? s=''
    suit.try(:downcase) == s.try(:downcase)
  end

  def is_a? val=''
    if(val.try(:to_i) == 0) #if a string is passed, eg "king" instead of 'k'
      face_value.try(:downcase)[0] == val.try(:downcase)[0]
    else
      face_value.try(:downcase) == val.try(:downcase)
    end
  end


end