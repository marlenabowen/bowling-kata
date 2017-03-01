 class Game
  def initialize
    @frame_rolls = []
    @frames_scores = []
  end

  def roll(pins)
    @frame_rolls.push(pins)
  end

  def frame_score
    if current_frame_strike?
      result = handle_strike_in_current_frame('typical frame')
    elsif current_frame_spare?
      result = handle_spare_in_current_frame
     else
      result = handle_current_frame
    end
    @frame_rolls.clear
    result
  end

  def final_frame_score
    if previous_frame_strike?
      if current_frame_strike?
        if frame_before_previous_is_strike?
          handle_three_strikes_in_a_row('final frame')
        else
          handle_previous_frame_score(20, @frame_rolls[0] + @frame_rolls[1] + @frame_rolls[2])
        end
      elsif current_frame_spare?
        handle_previous_frame_score(20, @frame_rolls[0] + @frame_rolls[1] + @frame_rolls[2])
      else
        handle_previous_frame_score(10 + @frame_rolls[0] + @frame_rolls[1], @frame_rolls[0] + @frame_rolls[1])
      end
    elsif previous_frame_spare?
      if current_frame_strike? || current_frame_spare?
        handle_previous_frame_score(10 + @frame_rolls[0], @frame_rolls[0] + @frame_rolls[1] + @frame_rolls[2])
      else
        handle_previous_frame_score(10 + @frame_rolls[0], @frame_rolls[0] + @frame_rolls[1])
      end
    else
      if current_frame_strike? || current_frame_spare?
        update_frames_scores(@frame_rolls[0] + @frame_rolls[1] + @frame_rolls[2])
      else
        update_frames_scores(@frame_rolls[0] + @frame_rolls[1])
      end
    end
  end

  def total_score
    number_of_frames = @frames_scores.length
    if previous_frame_strike?
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

  private

  def handle_strike_in_current_frame(frame)
    if previous_frame_strike?
      if frame_before_previous_is_strike?
        handle_three_strikes_in_a_row(frame)
      else
        handle_previous_frame_score(20, 'X')
      end
    else
      update_frames_scores('X')
    end
  end

  def handle_spare_in_current_frame
    if previous_frame_strike?
      handle_previous_frame_score(20, '/')
    elsif previous_frame_spare?
      handle_previous_frame_score(10 + @frame_rolls[0], '/')
    else
      update_frames_scores('/')
    end
  end

  def handle_current_frame
    first_roll = @frame_rolls[0]
    score_for_current_frame = first_roll + @frame_rolls[1]
    if previous_frame_strike?
      handle_score_after_strike
    elsif previous_frame_spare?
      handle_previous_frame_score(10 + first_roll, score_for_current_frame)
    else
      update_frames_scores(score_for_current_frame)
    end
  end

  def handle_three_strikes_in_a_row(frame)
    @frames_scores.pop
    @frames_scores.pop
    @frames_scores.push(30)
    if frame == 'final frame'
      @frames_scores.push(30)
      update_frames_scores(@frame_rolls[0] + @frame_rolls[1] + @frame_rolls[2])
    else
      @frames_scores.push(20)
      update_frames_scores('X')
    end
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

  def handle_score_after_strike
    score_for_current_frame = @frame_rolls[0] + @frame_rolls[1]
    @frames_scores.pop
    @frames_scores.push(10 + score_for_current_frame)
    @frames_scores.push(score_for_current_frame)
    @frames_scores.last
  end

  def current_frame_strike?
    @frame_rolls[0] == 10
  end

  def current_frame_spare?
    @frame_rolls[0] + @frame_rolls[1] == 10
  end

  def previous_frame_strike?
    @frames_scores.last == 'X'
  end

  def previous_frame_spare?
    @frames_scores.last == '/'
  end

  def frame_before_previous_is_strike?
    number_of_frames = @frames_scores.length
    @frames_scores[number_of_frames-2] == 20
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
