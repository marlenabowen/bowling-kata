class Frame
  attr_accessor :rolls
  attr_reader :type

  STRIKE = 'X'.freeze
  SPARE = '/'.freeze

  def initialize(type)
    @rolls = []
    @type = type
  end

  def add_roll(roll)
    @rolls << roll
  end

  def score
    if @rolls.first == 10
      STRIKE
    elsif @rolls.first + @rolls[1] == 10
      SPARE
    else
      @rolls.first + @rolls[1]
    end
  end
end
