require "spec_helper"
require "bowling.rb"

describe Game do
  describe "each frame" do
    context "when a strike is rolled" do
      it "records a score of 10 + the next frame's score" do
        game = Game.new
        game.roll(10)
        expect(game.frame_score).to eq('X')

        game.roll(7)
        game.roll(3)
        expect(game.frame_score).to eq('/')
      end
    end

    context "when a spare is rolled" do
      it "records a score of 10 + the next roll's score'" do
        game = Game.new
        game.roll(0)
        game.roll(10)
        expect(game.frame_score).to eq('/')

        game.roll(2)
        game.roll(4)
        expect(game.frame_score).to eq(6)
      end
    end

    context "more than 0 but less than ten pins were hit" do
      it "returns the total score" do
        game = Game.new
        game.roll(2)
        game.roll(6)
        expect(game.frame_score).to eq(8)
      end
    end

    context "no pins were hit" do
      it "returns the total score of 0" do
        game = Game.new
        game.roll(0)
        game.roll(0)
        expect(game.frame_score).to eq(0)
      end
    end

    context "in the final frame" do
      it "adds a third roll if a strike was rolled and scores appropriately" do
        game = Game.new
        game.roll(10)
        game.roll(3)
        game.roll(2)
        expect(game.final_frame_score).to eq(15)
      end

      it "adds a third roll if a spare was rolled and scores appropriately" do
        game = Game.new
        game.roll(5)
        game.roll(5)
        game.roll(2)
        expect(game.final_frame_score).to eq(12)
      end

      it "has only two rolls if neither a strike nor spare was rolled" do
        game = Game.new
        game.roll(4)
        game.roll(4)
        expect(game.final_frame_score).to eq(8)
      end
    end
  end

  context "entire game" do
    context "typical game" do
      it "returns the total score" do
        game = Game.new

        game.roll(10)
        expect(game.frame_score).to eq('X')

        game.roll(7)
        game.roll(3)
        expect(game.frame_score).to eq('/')
        expect(game.total_score).to eq(20)

        game.roll(5)
        game.roll(2)
        expect(game.frame_score).to eq(7)
        expect(game.total_score).to eq(42)

        game.roll(10)
        expect(game.total_score).to eq(42)

        game.roll(0)
        game.roll(0)
        expect(game.total_score).to eq(52)

        game.roll(7)
        game.roll(3)
        expect(game.total_score).to eq(52)

        game.roll(1)
        game.roll(0)
        expect(game.total_score).to eq(64)

        game.roll(0)
        game.roll(10)
        expect(game.total_score).to eq(64)

        game.roll(4)
        game.roll(4)
        expect(game.total_score).to eq(86)

        game.roll(1)
        game.roll(8)
        expect(game.total_score).to eq(95)
      end
    end

  #   context "perfect game" do
  #     it "returns a score of 300" do
  #       game = Game.new
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       game.roll(10)
  #       expect(game.total_score).to eq(300)
  #     end
  #   end
  end
end
