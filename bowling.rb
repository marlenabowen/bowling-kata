class Game
  def initialize
    @frame_rolls = []
    @frames = []
  end

  def roll(pins)
    @frame_rolls.push(pins)
  end

  def frame_score
    print @frame_rolls
    if @frame_rolls.length == 1
      frame_score = 'X'
      @frames.push(frame_score)
      result = @frames.last
    else
      total_pins = @frame_rolls[0] + @frame_rolls[1]
      last_frame_score = @frames.last
      if total_pins == 10 && last_frame_score != 'X'
        frame_score = '/'
        @frames.push(frame_score)
        result = @frames.last
      elsif total_pins == 10 && last_frame_score == 'X'
        previous_frame_score = 10 + total_pins
        @frames.pop
        @frames.push(previous_frame_score)
        current_frame_score = '/'
        @frames.push(current_frame_score)
        result = @frames.last
      elsif last_frame_score == 'X' && total_pins
        previous_frame_score = 10 + total_pins
        @frames.pop
        @frames.push(previous_frame_score)
        current_frame_score = total_pins
        @frames.push(current_frame_score)
        result = @frames.last
      elsif last_frame_score == '/'
        previous_frame_score = 10 + @frame_rolls[0]
        @frames.pop
        @frames.push(previous_frame_score)
        current_frame_score = total_pins
        @frames.push(current_frame_score)
        result = @frames.last
      else
        frame_score = total_pins
        @frames.push(frame_score)
        result = @frames.last
      end
    end
    @frame_rolls.clear
    result
  end

  def final_frame_score
    if @frame_rolls[0] == 10 || @frame_rolls[0] + @frame_rolls[1] == 10
      frame_score = @frame_rolls[0] + @frame_rolls[1] + @frame_rolls[2]
      @frames.push(frame_score)
      result = @frames[0]
    else
      frame_score = @frame_rolls[0] + @frame_rolls[1]
      @frames.push(frame_score)
      result = @frames.last
    end
  end

  def total_score
    print "start", @frames
    if @frames.last == 'X' || '/'
      print "one", @frames
      @frames.pop()
      print "two", @frames
      @frames.inject(0) { |sum,x| sum + x }
      print "three", @frames
      return @frames[0]
    else
      print "four", @frames
      @frames.inject(0) { |sum,x| sum + x }
      return @frames[0]
    end
  end
end

# accept a score for each roll equivalent to the number of pins knocked down, determine if strike

# if a strike is rolled:
  # do not accept another roll for that frame
  # record 'X' for this frame until next frame is finished
  # when the next frame is finished, record a score of 10 + the second frame's score to this frame

# group every two rolls or a strike into a frame
  # add those two roll scores to get the frame score
  # determine if spare
  # limit to 10 frames

# if a spare is rolled:
  # record '/' for this frame until next frame is finished
  # record a score of 10 + the score from the first roll of the next frame to this frame

# if a strike or spare are rolled in the final frame, allow one additional roll
