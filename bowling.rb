class Game
  def initialize
    @frame_rolls = []
    @frames_scores = []
  end

  def roll(pins)
    @frame_rolls.push(pins)
  end

  def frame_score
    number_of_frames = @frames_scores.length
    last_frame_score = @frames_scores.last
    if @frame_rolls[0] == 10 # if this frame is a strike
      if last_frame_score == 'X' # if the last frame is a strike
        if @frames_scores[number_of_frames-2] == 20 # if the frame before the last frame was a strike
          @frames_scores.pop
          @frames_scores.pop
          @frames_scores.push(30)
          @frames_scores.push(20)
          result = update_frames_scores('X')
        else # if the frame before the last frame was not a strike
          result = handle_previous_frame_score(20, 'X')
        end
      else # if the last frame was not a strike
        result = update_frames_scores('X')
      end
    else # if this frame is not a strike
      spare = 10 + @frame_rolls[0]
      two_rolls = @frame_rolls[0] + @frame_rolls[1]
      if two_rolls == 10 # if this frame is a spare
        if last_frame_score == 'X' # if the last frame was a strike
          result = handle_previous_frame_score(20, '/')
        elsif last_frame_score == '/' # if the last frame was a spare
          result = handle_previous_frame_score(spare, '/')
        else # if the last frame was not a strike or a spare
          result = update_frames_scores('/')
        end
      elsif last_frame_score == 'X' # if the last frame was a strike
        @frames_scores.pop
        @frames_scores.push(10 + two_rolls)
        result = handle_previous_frame_score(spare, two_rolls)
      elsif last_frame_score == '/' # the last frame was a spare
        result = handle_previous_frame_score(spare, two_rolls)
      else # if the last frame was not a strike or a spare
        result = update_frames_scores(two_rolls)
      end
    end
    @frame_rolls.clear
    result
  end

  def final_frame_score
    number_of_frames = @frames_scores.length
    spare = 10 + @frame_rolls[0]
    two_rolls = @frame_rolls[0] + @frame_rolls[1]
    last_frame_score = @frames_scores.last
    if last_frame_score == 'X' # if strike in last frame
      if @frame_rolls[0] == 10 # and if first roll of final frame is a strike
        if @frames_scores[number_of_frames-2] == 20 # and if a strike was also rolled in the frame before the last frame
          @frames_scores.pop
          @frames_scores.pop
          @frames_scores.push(30)
          @frames_scores.push(30)
          update_frames_scores(two_rolls + @frame_rolls[2])
        else # or if a strike was not bowled in the frame before the last frame
          handle_previous_frame_score(20, two_rolls + @frame_rolls[2])
        end
      elsif two_rolls == 10 # or if a strike was bowled in the final frame
        handle_previous_frame_score(20, two_rolls + @frame_rolls[2])
      else # or if neither a strike nor a spare was bowled in the final frame
        handle_previous_frame_score(10 + two_rolls, two_rolls)
      end
    elsif last_frame_score == '/' # or if the last frame was a spare
      if @frame_rolls[0] == 10 || two_rolls == 10 # and if the final frame includes a strike or spare
        handle_previous_frame_score(spare, two_rolls + @frame_rolls[2])
      else # or if the final frame does not include a strike or spare
        handle_previous_frame_score(spare, two_rolls)
      end
    else # or if the last frame was not a strike or spare
      if @frame_rolls[0] == 10 || two_rolls == 10
        update_frames_scores(two_rolls + @frame_rolls[2])
      else
        update_frames_scores(two_rolls)
      end
    end
  end

  def total_score
    number_of_frames = @frames_scores.length
    if @frames_scores.last == 'X' # if the last frame was a strike
      @frames_scores.pop
      if @frames_scores[number_of_frames-2] == 'X' # and if the frame before the last frame was a strike
        result = update_total_score(30)
      elsif @frames_scores[number_of_frames-2] == '/' # or if the frame before the last frame was a spare
        result = update_total_score(20)
      else #  or if the frame before the last frame was neither a strike nor a spare
        result = @frames_scores.inject(0) { |sum,x| sum + x }
      end
      @frames_scores.push('X')
    elsif @frames_scores.last == '/' # or if the last frame was a spare
      @frames_scores.pop
      if @frames_scores[number_of_frames-2] == 'X' # and if the frame before the last frame was a strike
        result = update_total_score(30)
      elsif @frames_scores[number_of_frames-2] == '/' # or if the frame before the last frame was a spare
        result = update_total_score(30)
      else # or if the frame before the last frame was neither a strike nor a spare
        result = @frames_scores.inject(0) { |sum,x| sum + x }
      end
      @frames_scores.push('/')
    else # or if the last frame was neither a strike nor a spare
      result = @frames_scores.inject(0) { |sum,x| sum + x }
    end
    result
  end

  def update_frames_scores(frame_score)
    @frames_scores.push(frame_score)
    @frames_scores.last
  end

  def update_total_score(updated_score)
    @frames_scores.pop
    @frames_scores.push(updated_score)
    @frames_scores.inject(0) { |sum,x| sum + x }
  end

  def handle_previous_frame_score(previous_frame_score, current_frame_score)
    @frames_scores.pop
    @frames_scores.push(previous_frame_score)
    update_frames_scores(current_frame_score)
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
