require "spec_helper"
require "game.rb"
require "frame.rb"

describe Game do
  context "in the final frame" do
    it "adds a third roll if a strike was rolled and scores appropriately" do
      game = Game.new
      frame = Frame.new(true)
      frame.add_roll(10)
      frame.add_roll(3)
      frame.add_roll(2)
      game.add_frame(frame)
      expect(game.score).to eq(15)
    end

    it "adds a third roll if a spare was rolled and scores appropriately" do
      game = Game.new
      frame = Frame.new(true)
      frame.add_roll(5)
      frame.add_roll(5)
      frame.add_roll(10)
      game.add_frame(frame)
      expect(game.score).to eq(20)
    end

    it "has only two rolls if neither a strike nor spare was rolled" do
      game = Game.new
      frame = Frame.new(true)
      frame.add_roll(4)
      frame.add_roll(4)
      game.add_frame(frame)
      expect(game.score).to eq(8)
    end
  end

  context "entire game" do
    context "typical game" do
      it "returns the total score" do
        game = Game.new
        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)
        expect(game.score).to eq(0)

        frame = Frame.new
        frame.add_roll(7)
        frame.add_roll(3)
        game.add_frame(frame)
        expect(game.score).to eq(20)

        frame = Frame.new
        frame.add_roll(5)
        frame.add_roll(2)
        game.add_frame(frame)
        expect(game.score).to eq(42)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)
        expect(game.score).to eq(42)

        frame = Frame.new
        frame.add_roll(0)
        frame.add_roll(0)
        game.add_frame(frame)
        expect(game.score).to eq(52)

        frame = Frame.new
        frame.add_roll(7)
        frame.add_roll(3)
        game.add_frame(frame)
        expect(game.score).to eq(52)

        frame = Frame.new
        frame.add_roll(0)
        frame.add_roll(10)
        game.add_frame(frame)
        expect(game.score).to eq(62)

        frame = Frame.new
        frame.add_roll(0)
        frame.add_roll(10)
        game.add_frame(frame)
        expect(game.score).to eq(72)

        frame = Frame.new
        frame.add_roll(10)
        frame.add_roll(0)
        game.add_frame(frame)
        expect(game.score).to eq(92)

        frame = Frame.new(true)
        frame.add_roll(1)
        frame.add_roll(8)
        game.add_frame(frame)
        expect(game.score).to eq(120)
      end
    end

    context "perfect game" do
      it "returns a score of 300" do
        game = Game.new
        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new
        frame.add_roll(10)
        game.add_frame(frame)

        frame = Frame.new(true)
        frame.add_roll(10)
        frame.add_roll(10)
        frame.add_roll(10)
        game.add_frame(frame)
        expect(game.score).to eq(300)
      end
    end
  end
end
