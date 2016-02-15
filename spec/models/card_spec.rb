require 'rails_helper'

RSpec.describe Card, :type => :model do

  context "constants" do
    describe "SUITS" do
      xit "should have suits" do
        expect(Card).to have_constant(:SUITS)
      end
      it "has 4 values" do
        expect(Card::SUITS.length).to eq 4
      end
    end
    describe "VALUES" do
      it "has 4 values" do
        expect(Card::VALUES.length).to eq 13
      end
    end
  end


  context "instance methods" do
    before :each do
      @c = Card.new('hearts', 'K')
    end      
    describe "is_suit?" do
      it "returns true if the instance's suit matches passed argument" do
        expect(@c.is_suit? 'hearts').to eq true
      end
      it "returns false if the passed value doesn't match " do
        expect(@c.is_suit? 'clubs').to eq false
      end
    end

    describe "is_a?" do
      it "returns true if the instance's value matches passed argument" do
        expect(@c.is_a? 'k').to eq true
      end
      it "accepts full face value names" do
        expect(@c.is_a? 'King').to eq true
      end
      it "returns false if the passed value doesn't match" do
        expect(@c.is_a? 'Jack').to eq false
      end
    end
  end
end