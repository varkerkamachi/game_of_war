require 'rails_helper'

RSpec.describe Game, :type => :model do
  context "instance methods" do
    describe "get_player_by_name" do
      it "returns the player with a name matching the passed argument" do
        p = Player.new('Giselle')
        p2 = Player.new('Wilbur')
        g = Game.new(1, 2, [p,p2])
        expect(g.get_player_by_name('wiLBUR')).to eq p2
      end
    end

    describe "is_game_over?" do
      before :each do
        @p = Player.new('Tommy')
        @p2 = Player.new('Shrek')
        @g = Game.new(1, 2, [@p,@p2])
        @g.start_game
      end
      it "returns true if any player has all the cards in the deck" do
        @p2.num_cards_remaining = Deck.num_cards
        expect(@g.is_game_over?).to eq true
      end
      it "also returns true if the state is set to 'stop'" do
        expect(@g.state).to eq 'play'
        @g.state = 'stop'
        expect(@g.is_game_over?).to eq true
      end
    end

    describe "end_game" do
      before :each do
        @p = Player.new('Garth')
        @p2 = Player.new('Samantha')
        @g = Game.new(1, 2, [@p, @p2])
        @g.start_game
      end
      it "sets the game state to 'stop'" do
        @g.end_game
        expect(@g.state).to eq 'stop'
      end

      it "sets the winner to 'true'" do
        @g.end_game
        expect(@g.winner).to eq true
      end

      it "sets the winning player to be the player with all the cards" do
        @p2.num_cards_remaining = Deck.num_cards
        @g.end_game
        expect(@g.winning_player).to eq @p2
      end
    end

  end
end