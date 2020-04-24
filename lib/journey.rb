require_relative './oystercard'

class Journey
  MIN_FARE = 1

  attr_reader :entry_station, :exit_station, :history

  def initialize
    @history = []
  end

  def start_journey(station)
     @entry_station = station
  end

  def in_journey?
    !!entry_station
  end

  def finish_journey(station)
    @exit_station = station
    @history << {:entry_station => @entry_station, :exit_station => @exit_station}
    @entry_station = nil
  end

end
