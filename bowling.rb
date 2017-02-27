class Game
  def roll(pins)
  end

  def score_for_frame
  end

  def total_score
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


### keep track of each frame and number of frames passed
