require_relative './journey'

class Oystercard
  LIMIT = 90
  MIN_FARE = 1
  attr_reader :balance, :journey

  def initialize(balance = 0, journey = Journey.new)
    @balance = balance
    @journey = journey
  end

  def top_up(amount)
    @balance + amount <= LIMIT ? @balance += amount : exceeds_balance_error
  end

  def touch_in(station)
    @balance >= MIN_FARE ? @journey.start_journey(station) : insufficient_balance_error
  end

  def touch_out(station)
    touch_out_error if @journey.in_journey? == false
    @journey.finish_journey(station)
    deduct(MIN_FARE)
  end

  private
  def exceeds_balance_error
    raise "Exceeds balance limit of #{LIMIT}"
  end

  def insufficient_balance_error
    raise "Insufficient balance to travel, at least £#{MIN_FARE} needed."
  end

  def touch_out_error
    raise "Card not touched in"
  end

  def deduct(amount)
    @balance -= amount
  end
end
