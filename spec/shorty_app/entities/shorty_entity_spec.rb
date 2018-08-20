require "spec_helper"
require 'securerandom'

describe ShortyApp::ShortyEntity do

  it 'should be defined' do
    expect(ShortyApp::ShortyEntity.class).to eq(Class)
  end

  context 'test ability to read by not write attributes' do

    before(:all) do
      @short_code = SecureRandom.urlsafe_base64(4).tr('-', '_')
      @url = 'google.com'
      @shorty_obj = ShortyApp::ShortyEntity.new(@short_code, @url)
    end

    def entity_define_method(method_name)
      expect(@shorty_obj.respond_to?(method_name)).to eq(true)
    end

    def entity_not_define_method(method_name)
      expect(@shorty_obj.respond_to?(method_name)).to_not eq(true)
    end

    context '#short_code' do
      it 'should read short_code' do
        entity_define_method(:short_code)
      end
      it 'should not write short_code' do
        entity_not_define_method(:short_code=)
      end
    end

    context '#url' do
      it 'should read url' do
        entity_define_method(:url)
      end
      it 'should not write url' do
        entity_not_define_method(:url=)
      end
    end

    context '#start_date' do
      it 'should read start_date' do
        entity_define_method(:start_date)
      end
      it 'should not write start_date' do
        entity_not_define_method(:start_date=)
      end
    end

    context '#last_seen_date' do
      it 'should read last_seen_date' do
        entity_define_method(:last_seen_date)
      end
      it 'should not write last_seen_date' do
        entity_not_define_method(:last_seen_date=)
      end
    end

    context '#redirect_count' do
      it 'should read redirect_count' do
        entity_define_method(:redirect_count)
      end
      it 'should not write redirect_count' do
        entity_not_define_method(:redirect_count=)
      end
    end
  end

  context '#initialize' do
    it 'shoudl initialize optional params correctly' do
      short_code = SecureRandom.urlsafe_base64(4).tr('-', '_')
      url = 'google.com'
      obj =ShortyApp::ShortyEntity.new(short_code, url)
      expect(obj.start_date.to_s).to eq(Time.now.to_s)
      expect(obj.last_seen_date).to eq(nil)
      expect(obj.redirect_count).to eq(0)
    end
  end

  context 'seen behaviour' do
    before(:all) do
      @short_code = SecureRandom.urlsafe_base64(4).tr('-', '_')
      @url = 'google.com'
      @shorty_obj = ShortyApp::ShortyEntity.new(@short_code, @url)
    end

    it 'should define seen! method' do
      expect(@shorty_obj.respond_to?(:seen!)).to eq(true)
    end

    it 'should increament redirect_count' do
      expect{@shorty_obj.seen!}.to change{@shorty_obj.redirect_count}.by(1)
    end

    it 'should update last_seen_date' do
      @shorty_obj.instance_variable_set(:@last_seen_date, nil)
      expect{@shorty_obj.seen!}.to change{@shorty_obj.last_seen_date.to_s}.to(Time.now.to_s)
    end
  end
end
