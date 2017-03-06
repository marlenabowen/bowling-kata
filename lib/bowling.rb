 class Game

  FINAL = 'final'.freeze
  STRIKE = 'X'.freeze
  SPARE = '/'.freeze

  def initialize
    @frame_rolls = []
    @frames_scores = []
  end

  def roll(pins)
    @frame_rolls << pins
  end

  def frame_score(frame)
    if frame == 10
      frame = FINAL
    end

    if current_frame_strike?
      result = frame_score_for_strike_or_spare(frame, STRIKE)
    elsif current_frame_spare?
      result = frame_score_for_strike_or_spare(frame, SPARE)
     else
      result = frame_score_without_strike_or_spare
    end
    @frame_rolls.clear
    result
  end

  def total_score
    if previous_frame_strike?
      sum_if_previous_frame_is_strike_or_spare(STRIKE)
    elsif previous_frame_spare?
      sum_if_previous_frame_is_strike_or_spare(SPARE)
    else
      sum
    end
  end

  private

  def current_frame_strike?
    @frame_rolls.first == 10
  end

  def current_frame_spare?
    @frame_rolls.first + @frame_rolls[1] == 10
  end

  def previous_frame_strike?
    @frames_scores.last == STRIKE
  end

  def previous_frame_spare?
    @frames_scores.last == SPARE
  end

  def frame_before_previous_is_strike?
    @frames_scores[-2] == 20
  end

  def frame_before_previous_is_spare?
    @frames_scores[-1] == SPARE
  end

  def frame_score_for_strike_or_spare(frame, current_frame_score)
    if frame == FINAL
      current_frame_score = @frame_rolls.first + @frame_rolls[1] + @frame_rolls[2]
    end

    if previous_frame_strike? && frame_before_previous_is_strike?
      three_strikes_in_a_row(frame)
    elsif previous_frame_strike?
      handle_previous_frame_score(20, current_frame_score)
    elsif previous_frame_spare?
      handle_previous_frame_score(10 + @frame_rolls.first, current_frame_score)
    else
      @frames_scores << current_frame_score
    end
    current_frame_score
  end

  def frame_score_without_strike_or_spare
    current_frame_score = @frame_rolls.first + @frame_rolls[1]
    if previous_frame_strike?
      handle_previous_frame_score(10 + current_frame_score, current_frame_score)
    elsif previous_frame_spare?
      handle_previous_frame_score(10 + @frame_rolls.first, current_frame_score)
    else
      @frames_scores << current_frame_score
    end
    current_frame_score
  end

  def sum_if_previous_frame_is_strike_or_spare(current_frame_score)
    @frames_scores.pop
    result = sum
    @frames_scores << current_frame_score
    result
  end

  def sum
    @frames_scores.reduce(0, :+)
  end

  def three_strikes_in_a_row(frame)
    @frames_scores.pop
    update_total_score(30)
    if frame == FINAL
      @frames_scores += [30, (@frame_rolls.first + @frame_rolls[1] + @frame_rolls[2])]
    else
      @frames_scores += [20, STRIKE]
    end
  end

  def handle_previous_frame_score(previous_frame_score, current_frame_score)
    update_total_score(previous_frame_score)
    @frames_scores << current_frame_score
  end

  def update_total_score(updated_score)
    @frames_scores.pop
    @frames_scores << updated_score
  end
end