require "spec_helper"
require "frame.rb"

describe Frame do
  context "when a strike is rolled" do
    it "records an X for that frame" do
      frame = Frame.new
      frame.add_roll(10)
      expect(frame.score).to eq('X')
    end
  end

  context "when a spare is rolled" do
    it "records a / for that frame" do
      frame = Frame.new
      frame.add_roll(0)
      frame.add_roll(10)
      expect(frame.score).to eq('/')

      frame.add_roll(7)
      frame.add_roll(3)
      expect(frame.score).to eq('/')
    end
  end

  context "more than 0 but less than ten pins were hit" do
    it "returns the total score" do
      frame = Frame.new
      frame.add_roll(2)
      frame.add_roll(6)
      expect(frame.score).to eq(8)
    end
  end

  context "no pins were hit" do
    it "returns the total score of 0" do
      frame = Frame.new
      frame.add_roll(0)
      frame.add_roll(0)
      expect(frame.score).to eq(0)
    end
  end
end
