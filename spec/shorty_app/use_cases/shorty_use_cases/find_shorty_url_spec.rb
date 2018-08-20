require "spec_helper"

describe ShortyApp::FindShortyUrl do

  it 'should be defined' do
    expect(ShortyApp::FindShortyUrl.class).to eq(Class)
    expect(ShortyApp::FindShortyUrl.superclass).to eq(ShortyApp::Base)
  end

  let(:short_code){SecureRandom.urlsafe_base64(4).tr('-', '_')}
  let!(:url){'google.com'}
  let!(:shorty_repo) {InMemoryDataStore::ShortyRepository.new}

  context '#initialization' do
    it 'should raise ShortCodeNotPresent when not present' do
      expect{ShortyApp::FindShortyUrl.new(nil)}.to raise_exception(ShortyApp::ShortyException::ShortCodeNotPresent)
    end

    it 'should raise ShortCodeNotPresent when not created yet' do
      expect{ShortyApp::FindShortyUrl.new(short_code, shorty_repo)}.to raise_exception(ShortyApp::ShortyException::ShortCodeNotPresent)
    end

    it 'should initialize shorty_repo' do
      shortcode = short_code
      ShortyApp::CreateShorty.new(url, shortcode, shorty_repo).perform
      expect(ShortyApp::FindShortyUrl.new(shortcode, shorty_repo).instance_variable_get(:@shorty_repo).class).to eq(shorty_repo.class)
    end

    it 'should initialize short_code' do
      shortcode = short_code
      ShortyApp::CreateShorty.new(url, shortcode, shorty_repo).perform
      expect(ShortyApp::FindShortyUrl.new(shortcode, shorty_repo).instance_variable_get(:@short_code)).to eq(shortcode)
    end
  end

  context '#perofm' do
    it 'should return hash with stats' do
      shortcode = short_code
      ShortyApp::CreateShorty.new(url, shortcode, shorty_repo).perform
      result_hash = ShortyApp::FindShortyUrl.new(shortcode, shorty_repo).perform
      expect(result_hash[:url]).to eq(url)
    end

    it 'should call seen!' do
      shortcode = short_code
      ShortyApp::CreateShorty.new(url, shortcode, shorty_repo).perform
      expect do
        ShortyApp::FindShortyUrl.new(shortcode, shorty_repo).perform
      end.to change{ShortyApp::FindShortyStats.new(shortcode, shorty_repo).perform[:redirect_count]}.by(1)
    end
  end
end
