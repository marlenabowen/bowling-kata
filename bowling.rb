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
    if @frame_rolls.length == 1
      if @frames_scores.last == 'X'
        if @frames_scores[number_of_frames-2] == 20
          @frames_scores.pop
          @frames_scores.pop
          @frames_scores.push(30)
          @frames_scores.push(20)
          result = update_frames_scores('X')
        else
          result = handle_previous_frame_score(20, 'X')
        end
      else
        result = update_frames_scores('X')
      end
    else
      spare = 10 + @frame_rolls[0]
      two_rolls = @frame_rolls[0] + @frame_rolls[1]
      last_frame_score = @frames_scores.last
      if two_rolls == 10
        if last_frame_score == 'X'
          result = handle_previous_frame_score(20, '/')
        elsif last_frame_score == '/'
          result = handle_previous_frame_score(spare, '/')
        else
          result = update_frames_scores('/')
        end
      elsif last_frame_score == 'X'
        @frames_scores.pop
        @frames_scores.push(10 + two_rolls)
        result = handle_previous_frame_score(spare, two_rolls)
      elsif last_frame_score == '/'
        result = handle_previous_frame_score(spare, two_rolls)
      else
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
    if last_frame_score == 'X' && @frame_rolls[0] == 10 && @frames_scores[number_of_frames-2] == 20
        @frames_scores.pop
        @frames_scores.pop
        @frames_scores.push(30)
        @frames_scores.push(30)
        update_frames_scores(two_rolls + @frame_rolls[2])
    elsif last_frame_score == '/'
      if @frame_rolls[0] == 10 || two_rolls == 10
        handle_previous_frame_score(spare, two_rolls + @frame_rolls[2])
      else
        handle_previous_frame_score(spare, two_rolls)
      end
    else
      if @frame_rolls[0] == 10 || two_rolls == 10
        update_frames_scores(two_rolls + @frame_rolls[2])
      else
        update_frames_scores(two_rolls)
      end
    end
  end

  def total_score
    number_of_frames = @frames_scores.length
    if (@frames_scores.last != 'X' && @frames_scores.last != '/') && (@frames_scores[number_of_frames-2] != 'X' && @frames_scores[number_of_frames-2] != '/')
      result = @frames_scores.inject(0) { |sum,x| sum + x }
    else
      last = @frames_scores.pop()
      result = @frames_scores.inject(0) { |sum,x| sum + x }
      @frames_scores.push(last)
    end
    result
  end

  def update_frames_scores(frame_score)
    @frames_scores.push(frame_score)
    @frames_scores.last
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
