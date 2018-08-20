require "spec_helper"

describe ShortyApp::Base do

  it 'should be defined' do
    expect(ShortyApp::Base.class).to eq(Class)
  end

  context '#initialization' do
    context 'test default initialization if nil passed to initialize' do
      before(:all) do
        @base_obj = ShortyApp::Base.new(nil)
      end

      it 'should initialize shorty_repo to be ShortyApp::ShortRepositoryInterface' do
        expect(@base_obj.instance_variable_get(:@shorty_repo)).to eq(ShortyApp::ShortRepositoryInterface)
      end
    end

    context 'test correct assignment of shorty_repo if data store object passed to it' do
      before(:all) do
        @base_obj = ShortyApp::Base.new(InMemoryDataStore::ShortyRepository.new)
      end

      it 'should initialize shorty_repo to be ShortyApp::ShortRepositoryInterface' do
        expect(@base_obj.instance_variable_get(:@shorty_repo).class).to eq(InMemoryDataStore::ShortyRepository)
      end
    end
  end

  context 'ShortyApp::Base behaviour' do
    before(:all) do
      @base_obj = ShortyApp::Base.new(nil)
      @short_code = SecureRandom.urlsafe_base64(4).tr('-', '_')
      @url = 'google.com'
      @shorty_obj = ShortyApp::ShortyEntity.new(@short_code, @url)
    end

    context '#create!' do
      it 'shoud have private create! method' do
        expect(@base_obj.private_methods).to include(:create!)
      end

      it 'should call create! from datastore object' do
        expect{@base_obj.send(:create!, @shorty_obj)}.to raise_exception(NotImplementedError)
      end
    end

    context '#find' do
      it 'shoud have private find method' do
        expect(@base_obj.private_methods).to include(:find)
      end

      it 'should call find from datastore object' do
        expect{@base_obj.send(:find, @short_code)}.to raise_exception(NotImplementedError)
      end
    end

    context '#exists?' do
      it 'shoud have private exists? method' do
        expect(@base_obj.private_methods).to include(:exists?)
      end

      it 'should call exists? from datastore object' do
        expect{@base_obj.send(:exists?, @shorty_obj)}.to raise_exception(NotImplementedError)
      end
    end

    context '#seen!' do
      it 'shoud have private seen! method' do
        expect(@base_obj.private_methods).to include(:seen!)
      end

      it 'should call seen! from ShortyEntity object' do
        expect{
          begin
            @base_obj.send(:seen!, @shorty_obj)
          rescue NotImplementedError
          end
        }.to change{@shorty_obj.redirect_count}.by(1)
      end

      it 'should call save! from datastore object' do
        expect{@base_obj.send(:seen!, @shorty_obj)}.to raise_exception(NotImplementedError)
      end
    end
  end
end
