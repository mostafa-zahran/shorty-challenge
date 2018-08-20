require "spec_helper"

describe ShortyWebApp::ShortyStatsPresenter do

  it 'should be defined' do
    expect(ShortyWebApp::ShortyStatsPresenter.class).to eq(Class)
  end

  let(:stats_no_visit){{start_date: Time.now.to_s, redirect_count: 0, last_seen_date: nil}}
  let(:stats_with_visit){{start_date: Time.now.to_s, redirect_count: rand(10), last_seen_date: Time.now.to_s}}

  context '#initialize' do
    it 'should initialize params correctly' do
      stats = stats_no_visit
      visited_stats = stats_with_visit
      expect(ShortyWebApp::ShortyStatsPresenter.new(stats).instance_variable_get(:@stats)).to eq(stats)
      expect(ShortyWebApp::ShortyStatsPresenter.new(visited_stats).instance_variable_get(:@stats)).to eq(visited_stats)
    end
  end

  context '#perform' do
    it 'should return correct json' do
      stats = stats_no_visit
      visited_stats = stats_with_visit
      expect(ShortyWebApp::ShortyStatsPresenter.new(stats).perform).to eq({
        startDate: Time.parse(stats[:start_date]).iso8601,
        redirectCount: stats[:redirect_count]
      }.to_json)
      expect(ShortyWebApp::ShortyStatsPresenter.new(visited_stats).perform).to eq({
        startDate: Time.parse(visited_stats[:start_date]).iso8601,
        redirectCount: visited_stats[:redirect_count],
        lastSeenDate: Time.parse(visited_stats[:last_seen_date]).iso8601,
      }.to_json)
    end
  end

  context '#last_seen_hash' do
    it 'should conditionally add last_seen_date based on redirect_count' do
      visited_stats = stats_with_visit
      expect(ShortyWebApp::ShortyStatsPresenter.new(stats_no_visit).send(:last_seen_hash)).to eq({})
      expect(ShortyWebApp::ShortyStatsPresenter.new(visited_stats).send(:last_seen_hash)).to eq({lastSeenDate: Time.parse(visited_stats[:last_seen_date]).iso8601})
    end
  end
end
