require "spec_helper"
require 'securerandom'

describe ShortyWebApp::ErrorsPresenter do

  it 'should be defined' do
    expect(ShortyWebApp::ErrorsPresenter.class).to eq(Class)
  end

  let(:error_text){SecureRandom.hex(10)}

  context '#initialize' do
    it 'should initialize params correctly' do
      desc = error_text
      expect(ShortyWebApp::ErrorsPresenter.new(desc).instance_variable_get(:@desc)).to eq(desc)
    end
  end

  context '#perform' do
    it 'should return correct json' do
      desc = error_text
      expect(ShortyWebApp::ErrorsPresenter.new(desc).perform).to eq({
        errors: desc
      }.to_json)
    end
  end
end
