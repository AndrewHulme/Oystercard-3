class Oystercard
  LIMIT = 90
  MIN_FARE = 1
  attr_reader :balance, :entry_station#, :in_journey

  def initialize(balance = 0)
    @balance = balance
    #@in_journey = false
  end

  def in_journey?
    !!entry_station
  end


  def top_up(amount)
    @balance + amount <= LIMIT ? @balance += amount : exceeds_balance_error
  end

  def touch_in(station)
    @balance >= MIN_FARE ? @entry_station = station : insufficient_balance_error
  end

  def touch_out
    in_journey? ? @entry_station = nil : touch_out_error
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
