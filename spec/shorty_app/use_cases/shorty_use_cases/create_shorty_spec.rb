require "spec_helper"
require 'securerandom'

describe ShortyApp::CreateShorty do

  it 'should be defined' do
    expect(ShortyApp::CreateShorty.class).to eq(Class)
    expect(ShortyApp::CreateShorty.superclass).to eq(ShortyApp::Base)
    expect(ShortyApp::CreateShorty.const_get(:USER_CODE_REGEX)).to eq(/^[0-9a-zA-Z_]{4,}$/)
    expect(ShortyApp::CreateShorty.const_get(:SYSTEM_CODE_REGEX)).to eq(/^[0-9a-zA-Z_]{6}$/)
  end

  let(:short_code){SecureRandom.urlsafe_base64(4).tr('-', '_')}
  let!(:url){'google.com'}
  let!(:shorty_repo) {InMemoryDataStore::ShortyRepository.new}
  let!(:create_shorty_dummy) {ShortyApp::CreateShorty.new(url, short_code, InMemoryDataStore::ShortyRepository.new)}

  context '#initialization' do
    it 'should raise UrlNotPresent when not present' do
      expect{ShortyApp::CreateShorty.new(nil, short_code, shorty_repo)}.to raise_exception(ShortyApp::ShortyException::UrlNotPresent)
    end

    it 'should raise ShortCodeBadFormat short_code given and not match correct format' do
      expect{ShortyApp::CreateShorty.new(url, '12', shorty_repo)}.to raise_exception(ShortyApp::ShortyException::ShortCodeBadFormat)
      expect{ShortyApp::CreateShorty.new(url, nil, shorty_repo)}.to_not raise_error
    end

    it 'should raise ShortCodeInUse short_code given and already in use' do
      shortcode = short_code
      ShortyApp::CreateShorty.new(url, shortcode, shorty_repo).perform
      expect{ShortyApp::CreateShorty.new(url, shortcode, shorty_repo)}.to raise_exception(ShortyApp::ShortyException::ShortCodeInUse)
    end

    it 'should initialize shorty_repo' do
      expect(ShortyApp::CreateShorty.new(url, short_code, shorty_repo).instance_variable_get(:@shorty_repo).class).to eq(shorty_repo.class)
    end

    it 'should initialize url' do
      expect(ShortyApp::CreateShorty.new(url, short_code, shorty_repo).instance_variable_get(:@url)).to eq(url)
    end

    it 'should set short_code if given' do
      shortcode = short_code
      expect(ShortyApp::CreateShorty.new(url, shortcode, shorty_repo).instance_variable_get(:@short_code)).to eq(shortcode)
    end

    it 'should generate short_code if NOT given' do
      expect(ShortyApp::CreateShorty.new(url, nil, shorty_repo).instance_variable_get(:@short_code)).to_not eq(nil)
    end
  end

  context '#perform' do
    context 'should create in data store given' do
      context 'in memory data store' do
        let!(:create_shorty_in_memory_obj) {ShortyApp::CreateShorty.new(url, short_code, InMemoryDataStore::ShortyRepository.new)}
        it 'should create in memory and return short_code' do
          shortcode = create_shorty_in_memory_obj.instance_variable_get(:@short_code)
          return_value = create_shorty_in_memory_obj.perform
          expect(InMemoryDataStore::ShortyRepository.new.exists?(shortcode)).to eq(true)
          expect(return_value[:shortcode] == shortcode)
        end
      end

      context 'in redis data store' do
        let!(:create_shorty_in_redis_obj) {ShortyApp::CreateShorty.new(url, short_code, RedisDataStore::ShortyRepository.new)}
        it 'should create in memory' do
          shortcode = create_shorty_in_redis_obj.instance_variable_get(:@short_code)
          return_value = create_shorty_in_redis_obj.perform
          expect(RedisDataStore::ShortyRepository.new.exists?(shortcode)).to eq(true)
          expect(return_value[:shortcode] == shortcode)
        end
      end
    end
  end

  context '#shorty' do
    it 'should return ShortyEntity object' do
      expect(create_shorty_dummy.send(:shorty).class).to eq(ShortyApp::ShortyEntity)
    end

    it 'should be memorization method' do
      expect(create_shorty_dummy.send(:shorty).object_id).to eq(create_shorty_dummy.send(:shorty).object_id)
    end
  end

  context '#generate_random' do
    it 'should return different string every time' do
      expect(create_shorty_dummy.send(:generate_random).class).to eq(String)
      expect(create_shorty_dummy.send(:generate_random)).to_not eq(create_shorty_dummy.send(:generate_random))
    end
  end

  context '#generate_short_code' do
    before(:context) do
      ShortyApp::CreateShorty.class_eval do
        def generate_random
          @number_of_call ||= 0
          return_index = @number_of_call
          values = ['12', '123456', '123456', 'abcdef']
          @number_of_call += 1
          values[return_index]
        end
      end
    end
    let!(:use_in_memory) {ShortyApp::CreateShorty.new(url, nil, InMemoryDataStore::ShortyRepository.new)}
    it 'should validate against bad format' do
      expect(use_in_memory.instance_variable_get(:@short_code)).to eq('123456')
      expect(use_in_memory.instance_variable_get(:@number_of_call)).to eq(2)
    end

    it 'should validate against in use' do
      use_in_memory.perform
      use_in_memory2 = ShortyApp::CreateShorty.new(url, nil, InMemoryDataStore::ShortyRepository.new)
      expect(use_in_memory2.instance_variable_get(:@short_code)).to eq('abcdef')
      expect(use_in_memory2.instance_variable_get(:@number_of_call)).to eq(4)
    end
  end
end
