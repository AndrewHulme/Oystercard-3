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

  let(:entry_station) { double() }
  let(:exit_station) { double() }
  let(:hibo) { double() }
  let(:andrew) { double() }

  it "has a balance" do
    expect(subject).to respond_to(:balance)
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

    context "card has less than £#{min_fare}" do
      it "raises an error" do
        expect { subject.touch_in(entry_station) }.to raise_error("Insufficient balance to travel, at least £#{min_fare} needed.")
      end
    end
  end

  describe '#touch_out' do
    context "card is touched out" do
      it "raises an error" do
        expect { subject.touch_out(exit_station) }.to raise_error("Card not touched in")
      end
    end
  end

  it "checks if fare for the journey has been deducted from balance" do
    subject.top_up(10)
    subject.touch_in(entry_station)
    expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-1)
  end
end

  #let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
