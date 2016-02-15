require 'rails_helper'

RSpec.describe Game, :type => :model do
  context "instance methods" do
    describe "get_player_by_name" do
      it "returns the player with a name matching the passed argument" do
        p = Player.new('Giselle')
        p2 = Player.new('Wilbur')
        g = Game.new(2, [p,p2])
        expect(g.get_player_by_name('wiLBUR')).to eq p2
      end
    end
  end
end