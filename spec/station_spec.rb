require './lib/station'

describe Station do

  it 'outputs the station zone' do
    paddington = Station.new("Paddington", "Zone 1")
    expect(paddington.zone).to eq "Zone 1"
  end

  it 'outputs the station name' do
    paddington = Station.new("Paddington", "Zone 1")
    expect(paddington.name).to eq "Paddington"
  end

end
