require "spec_helper"
require 'securerandom'

describe InMemoryDataStore::ShortyRepository do

  context 'definiation' do
    it 'should be defined' do
      expect(InMemoryDataStore::ShortyRepository.class).to eq(Class)
    end
    it 'should include ShortRepositoryInterface' do
      expect(InMemoryDataStore::ShortyRepository.included_modules).to include(ShortyApp::ShortRepositoryInterface)
    end
  end

  context 'ShortyRepository behaviour' do
    let!(:repo_obj) {InMemoryDataStore::ShortyRepository.new}

    before(:all) do
      @short_code = SecureRandom.urlsafe_base64(4).tr('-', '_')
      @url = 'google.com'
      @shorty_obj = ShortyApp::ShortyEntity.new(@short_code, @url)
    end

    context '#create!' do
      it 'can add shorty object to in memory $storage' do
        repo_obj.create!(@shorty_obj)
        expect($storage[@short_code][:url]).to eq(@url)
      end
    end

    context '#find' do
      it 'can find shorty object' do
        entity = repo_obj.find(@shorty_obj.short_code)
        expect(entity.class).to eq(ShortyApp::ShortyEntity)
        expect(entity.short_code).to eq(@shorty_obj.short_code)
        expect(entity.url).to eq(@shorty_obj.url)
        expect(entity.start_date.to_s).to eq(@shorty_obj.start_date.to_s)
        expect(entity.last_seen_date.to_s).to eq(@shorty_obj.last_seen_date.to_s)
        expect(entity.redirect_count).to eq(@shorty_obj.redirect_count)
      end

      it 'can NOT find shorty object' do
        expect{repo_obj.find(@shorty_obj.short_code + @shorty_obj.short_code)}.to raise_error(KeyError)
      end
    end

    context '#exists?' do
      it 'return true if exists' do
        expect(repo_obj.exists?(@shorty_obj.short_code)).to eq(true)
      end

      it 'return false if NOT exists' do
        expect(repo_obj.exists?(@shorty_obj.short_code + @shorty_obj.short_code)).to eq(false)
      end
    end

    context '#save!' do
      it 'can modify shorty object' do
        expect do
          @shorty_obj.instance_variable_set(:@redirect_count,  @shorty_obj.redirect_count + 1)
          repo_obj.save!(@shorty_obj)
        end.to change{$storage[@shorty_obj.short_code][:redirect_count]}.by(1)
      end
    end

    context '#key' do
      it 'should return short_code as a key' do
        expect(repo_obj.send(:key, @shorty_obj)).to eq(@shorty_obj.short_code)
      end
    end

    context '#value' do
      it 'should return other attrs but not short_code in a hash' do
        result_hash = repo_obj.send(:value, @shorty_obj)
        expect(result_hash.keys - [:url, :start_date, :last_seen_date, :redirect_count]).to eq([])
        expect(result_hash[:url]).to eq(@shorty_obj.url)
        expect(result_hash[:start_date]).to eq(@shorty_obj.start_date.to_s)
        expect(result_hash[:last_seen_date]).to eq(@shorty_obj.last_seen_date.to_s)
        expect(result_hash[:redirect_count]).to eq(@shorty_obj.redirect_count)
      end
    end
  end
end
