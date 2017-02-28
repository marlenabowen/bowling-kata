class Game
  def initialize
    @frame_rolls = []
    @frames = []
  end

  def roll(pins)
    @frame_rolls.push(pins)
  end

  def frame_score
    number_of_frames = @frames.length
    if @frame_rolls.length == 1 && @frames.last != 'X'
      frame_score = 'X'
      @frames.push(frame_score)
      result = @frames.last
    elsif @frame_rolls.length == 1 && @frames.last == 'X' && (@frames[number_of_frames-2] != 20)
      previous_frame_score = 20
      @frames.pop
      @frames.push(previous_frame_score)
      current_frame_score = 'X'
      @frames.push(current_frame_score)
      result = @frames.last
    elsif @frame_rolls.length == 1 && @frames.last == 'X' && (@frames[number_of_frames-2] == 20)
      score_from_two_frames_ago = 30
      previous_frame_score = 20
      @frames.pop
      @frames.pop
      @frames.push(score_from_two_frames_ago)
      @frames.push(previous_frame_score)
      current_frame_score = 'X'
      @frames.push(current_frame_score)
      result = @frames.last
    else
      total_pins = @frame_rolls[0] + @frame_rolls[1]
      last_frame_score = @frames.last
      if total_pins == 10 && (last_frame_score != 'X' && last_frame_score != '/')
        frame_score = '/'
        @frames.push(frame_score)
        result = @frames.last
      elsif total_pins == 10 && last_frame_score == 'X'
        @frames.pop
        @frames.push(20)
        current_frame_score = '/'
        @frames.push(current_frame_score)
        result = @frames.last
      elsif total_pins == 10 && last_frame_score == '/'
        previous_frame_score = 10 + @frame_rolls[0]
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
    first_two_rolls = @frame_rolls[0] + @frame_rolls[1]
    number_of_frames = @frames.length
    if @frames.last == 'X'
      if @frame_rolls[0] == 10
        if @frames[number_of_frames-2] == 20
          @frames.pop
          @frames.pop
          @frames.push(30)
          @frames.push(30)
          frame_score = @frame_rolls[0] + @frame_rolls [1] + @frame_rolls[2]
          @frames.push(frame_score)
          result = @frames.last
        else
          @frames.pop
          @frames.push(20)
          frame_score = @frame_rolls[0] + @frame_rolls [1] + @frame_rolls[2]
          @frames.push(frame_score)
          result = @frames.last
        end
      elsif first_two_rolls == 10
        @frames.pop
        @frames.push(20)
        frame_score = @frame_rolls[0] + @frame_rolls [1] + @frame_rolls[2]
        @frames.push(frame_score)
        result = @frames.last
      else
        @frames.pop
        @frames.push(10 + @frame_rolls[0])
        frame_score = @frame_rolls[0] + @frame_rolls [1]
        @frames.push(frame_score)
        result = @frames.last
      end
    elsif @frames.last == '/'
      if (@frame_rolls[0] == 10 || first_two_rolls == 10)
        @frames.pop
        previous_frame_score = 10 + @frame_rolls[0]
        @frames.push(previous_frame_score)
        frame_score = @frame_rolls[0] + @frame_rolls [1] + @frame_rolls[2]
        @frames.push(frame_score)
        result = @frames.last
      else
        @frames.pop
        previous_frame_score = 10 + @frame_rolls[0]
        @frames.push(previous_frame_score)
        frame_score = @frame_rolls[0] + @frame_rolls[1]
        @frames.push(frame_score)
        result = @frames.last
      end
    else
      if (@frame_rolls[0] == 10 || first_two_rolls == 10)
        frame_score = first_two_rolls + @frame_rolls[2]
        @frames.push(frame_score)
        result = @frames.last
      else
        frame_score = first_two_rolls
        @frames.push(frame_score)
        result = @frames.last
      end
    end
    return result
  end

  def total_score
    number_of_frames = @frames.length
    if (@frames.last != 'X' && @frames.last != '/') && (@frames[number_of_frames-2] != 'X' && @frames[number_of_frames-2] != '/')
      result = @frames.inject(0) { |sum,x| sum + x }
    else
      last = @frames.pop()
      result = @frames.inject(0) { |sum,x| sum + x }
      @frames.push(last)
    end
    return result
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
