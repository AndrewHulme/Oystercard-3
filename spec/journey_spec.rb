require 'journey'
require 'oystercard'
require 'station'

describe Journey do
  let(:card) {Oystercard.new}
  let(:piccadilly) {Station.new("Piccadilly", "Zone 1")}
  let(:waterloo) {Station.new("Waterloo", "Zone 1")}
  let(:bank) {Station.new("Bank", "Zone 1")}
  let(:cockfosters) {Station.new("Cockfosters", "Zone 5")}

  describe '#start_journey' do

    it "remembers entry station" do
      card.top_up(10)
      card.touch_in(piccadilly)
      expect(card.journey.entry_station).to eq piccadilly
    end


    it "checks if in_journey is true if card is touched in" do
      card.top_up(10)
      card.touch_in(piccadilly)
      expect(card.journey.in_journey?).to eq true
    end
  end

  describe '#touch_out' do
    context "balance is" do
      it "checks if in_journey is false if card is touched out" do
        card.top_up(10)
        card.touch_in(piccadilly)
        card.touch_out(waterloo)
        expect(card.journey.in_journey?).to be false
      end
    end

    it 'store journey history' do
      card.top_up(10)
      card.touch_in(piccadilly)
      card.touch_out(waterloo)
      expect(card.journey.exit_station).to eq(waterloo)
    end
  end 

  it 'starts with an empty hash' do
    expect(subject.history).to be_empty
  end

  it 'stores journey history' do
    journey = {:entry_station => piccadilly, :exit_station => waterloo}
    card.top_up(10)
    card.touch_in(piccadilly)
    card.touch_out(waterloo)
    expect(card.journey.history).to include journey
  end

  it 'stores multiple journeys in the history of the card' do
    card.top_up(10)
    card.touch_in(piccadilly)
    card.touch_out(waterloo)

    card.touch_in(bank)
    card.touch_out(cockfosters)
    expect(card.journey.history).to eq [{:entry_station => piccadilly, :exit_station => waterloo}, {:entry_station => bank, :exit_station => cockfosters}]
  end

  it "forgets entry_station on finish_journey" do
    card.top_up(10)
    card.touch_in(piccadilly)
    card.touch_out(waterloo)
    expect(card.journey.entry_station).to eq nil
  end
end
