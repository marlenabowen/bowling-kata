class Game
  def initialize
    @frame_rolls = []
    @frame_score = []
    @frames = []
  end

  def roll(pins)
    @frame_rolls.push(pins)
  end

  def score_for_frame(frame)
    if frame < 10
      if @frame_rolls[0] == 10 && !@frame_rolls[1]
        frame_score = 'X'
        @frame_score.push(frame_score)
        result = @frame_score[frame-1]
      elsif @frame_rolls[0] + @frame_rolls[1] == 10 && !@frame_rolls[2] && @frame_score[frame-1] != 'X'
        frame_score = '/'
        @frame_score.push(frame_score)
        result = @frame_score[frame-1]
      elsif @frame_rolls[0] + @frame_rolls[1] == 10 && !@frame_rolls[2] && @frame_score[frame-1] == 'X'
        previous_frame_score = 10 + @frame_rolls[0] + @frame_rolls[1]
        @frame_score[frame-1] = previous_frame_score
        current_frame_score = '/'
        @frame_score.push(current_frame_score)
        result = @frame_score[frame-1]
      elsif @frame_score[frame-1] == 'X' && @frame_rolls[0] && @frame_rolls[1]
        previous_frame_score = 10 + @frame_rolls[0] + @frame_rolls[1]
        @frame_score[frame-1] = previous_frame_score
        current_frame_score = @frame_rolls[0] + @frame_rolls[1]
        @frame_score.push(current_frame_score)
        result = @frame_score[frame-1]
      elsif @frame_score[frame-1] == '/' && @frame_rolls[0]
        previous_frame_score = 10 + @frame_rolls[0]
        @frame_score[frame-1] = previous_frame_score
        current_frame_score = @frame_rolls[0] + @frame_rolls[1]
        @frame_score.push(current_frame_score)
        result = @frame_score[frame-1]
      else
        frame_score = @frame_rolls[0] + @frame_rolls[1]
        @frame_score.push(frame_score)
        result = @frame_score[frame-1]
      end
    else
      if @frame_rolls[0] == 10 || @frame_rolls[0] + @frame_rolls[1] == 10
        frame_score = @frame_rolls[0] + @frame_rolls[1] + @frame_rolls[2]
        @frame_score.push(frame_score)
        result = @frame_score[0]
      else
        frame_score = @frame_rolls[0] + @frame_rolls[1]
        @frame_score.push(frame_score)
        result = @frame_score.last
      end
    end
    @frame_rolls.clear
    result
  end

  def total_score
    ## if last score is '/' or 'X', return sum of all scores before that
    ## else return sum of all scores
    @frame_score
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
