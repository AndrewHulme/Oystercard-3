class Oystercard
  LIMIT = 90
  MIN_FARE = 1
  attr_reader :balance, :entry_station, :exit_station, :history

  def initialize(balance = 0)
    @balance = balance
    @history = {}
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

  def touch_out(station)
    save_entry
    in_journey? ? @entry_station = nil : touch_out_error
    deduct(MIN_FARE)
    @exit_station = station
    save_exit
  end

  def save_entry
    @history[:entry_station] = @entry_station
  end

  def save_exit
    @history[:exit_station] = @exit_station
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
