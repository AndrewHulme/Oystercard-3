require './lib/oystercard'

shared_context "above minimum" do
  let(:subject) do
    subject = described_class.new
    subject.top_up(50)
    subject
  end
end

describe Oystercard do
  limit = Oystercard::LIMIT
  min_fare = Oystercard::MIN_FARE

  let(:station) { double() }


  it "has a balance" do
    expect(subject).to respond_to(:balance)
  end

  it "checks if a card can show if it's in_journey?" do
    expect(subject).to respond_to(:in_journey?)
  end

  describe "#top_up" do
    it "tops up the card with a specified balance" do
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end

    it "returns exceed limit error if top_up exceeds balance limit of #{limit}" do
      subject.top_up(50)
      expect { subject.top_up(50) }.to raise_error("Exceeds balance limit of #{limit}")
    end
  end

  describe '#touch_in' do

    context "balance is" do
      include_context 'above minimum'
      it "checks if in_journey is true if card is touched in" do
        subject.touch_in(station)
        expect(subject.in_journey?).to eq true
      end


      it "remembers entry station" do
        subject.touch_in(station)
        expect(subject.entry_station).to eq station
      end
    end

    context "card has less than £#{min_fare}" do
      it "raises an error" do
        expect { subject.touch_in(station) }.to raise_error("Insufficient balance to travel, at least £#{min_fare} needed.")
      end
    end

  end

  describe '#touch_out' do
    context "balance is" do
      include_context 'above minimum'
      it "checks if in_journey is false if card is touched out" do
        subject.touch_in(station)
        subject.touch_out
        expect(subject.in_journey?).to be false
      end

      it "checks if fare for the journey has been deducted from balance" do
        subject.touch_in(station)
        expect { subject.touch_out }.to change { subject.balance }.by(-1)
      end
    end

    context "card is touched out" do
      it "raises an error" do
        expect { subject.touch_out }.to raise_error("Card not touched in")
      end
    end
  end

  describe 'entry_station' do
    include_context 'above minimum'

    it "forgets entry_station on touch_out" do
      subject.touch_in(station)
      subject.touch_out
      expect(subject.entry_station).to eq nil
    end
  end










end
