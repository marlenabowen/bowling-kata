class Game
  STRIKE = 'X'.freeze
  SPARE = '/'.freeze

  def initialize
    @frame_scores = []
  end

  def add_frame(frame)
    handle_frame_score(frame)
  end

  def score
    if previous_frame_strike?
      sum_if_previous_frame_is_strike_or_spare(STRIKE)
    elsif previous_frame_spare?
      sum_if_previous_frame_is_strike_or_spare(SPARE)
    else
      sum(@frame_scores)
    end
  end

  private

  def previous_frame_strike?
    @frame_scores.last == STRIKE
  end

  def previous_frame_spare?
    @frame_scores.last == SPARE
  end

  def frame_before_previous_is_strike?
    @frame_scores[-2] == 20
  end

  def frame_before_previous_is_spare?
    @frame_scores[-1] == SPARE
  end

  def handle_frame_score(frame)
    if frame.score == STRIKE
      result = frame_score_for_strike_or_spare(frame)
    elsif frame.score == SPARE
      result = frame_score_for_strike_or_spare(frame)
    else
      result = frame_score_without_strike_or_spare(frame)
    end
    result
  end

  def frame_score_for_strike_or_spare(frame)
    if frame.is_final
      score = frame.rolls.first + frame.rolls[1] + frame.rolls[2]
    else
      score = frame.score
    end

    if previous_frame_strike? && frame_before_previous_is_strike?
      three_strikes_in_a_row(frame)
    elsif previous_frame_strike?
      handle_previous_frame_score(20, frame)
    elsif previous_frame_spare?
      handle_previous_frame_score(10 + frame.rolls.first, frame)
    else
      @frame_scores << score
    end
    score
  end

  def frame_score_without_strike_or_spare(frame)
    current_frame_score = frame.rolls.first + frame.rolls[1]
    if previous_frame_strike?
      handle_previous_frame_score(10 + frame.score, frame)
    elsif previous_frame_spare?
      handle_previous_frame_score(10 + frame.rolls.first, frame)
    else
      @frame_scores << frame.score
    end
    frame.score
  end

  def sum_if_previous_frame_is_strike_or_spare(frame)
    if @frame_scores.length == 1
      result = 0
    else
      last_frame = @frame_scores.pop
      result = sum(@frame_scores)
      @frame_scores << last_frame
    end
    result
  end

  def sum(scores)
    total_score = 0
    scores.each do |score|
      total_score = total_score + score
    end
    total_score
  end

  def three_strikes_in_a_row(frame)
    @frame_scores.pop
    update_total_score(30)
    if frame.is_final
      @frame_scores += [30, (frame.rolls.first + frame.rolls[1] + frame.rolls[2])]
    else
      @frame_scores += [20, STRIKE]
    end
  end

  def handle_previous_frame_score(previous_frame_score, frame)
    update_total_score(previous_frame_score)
    @frame_scores << frame.score
  end

  def update_total_score(updated_score)
    @frame_scores.pop
    @frame_scores << updated_score
  end
end
