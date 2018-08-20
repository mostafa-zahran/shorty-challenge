require "spec_helper"

describe ShortyWebApp::ShortyController do

  it 'should be defined' do
    expect(ShortyWebApp::ShortyController.class).to eq(Class)
  end

  context '#initialize' do
    it 'should initialize optional params correctly' do
      expect(ShortyWebApp::ShortyController.new(InMemoryDataStore::ShortyRepository.new).
        instance_variable_get(:@data_store).class).to eq(InMemoryDataStore::ShortyRepository)
      expect(ShortyWebApp::ShortyController.new(RedisDataStore::ShortyRepository.new).
        instance_variable_get(:@data_store).class).to eq(RedisDataStore::ShortyRepository)
      expect(ShortyWebApp::ShortyController.new(nil).instance_variable_get(:@data_store).class).to eq(NilClass)
    end
  end

  let!(:url){'google.com'}
  let(:short_code) {SecureRandom.urlsafe_base64(4).tr('-', '_')}
  let!(:data_store){InMemoryDataStore::ShortyRepository.new}
  let!(:controller_obj){ShortyWebApp::ShortyController.new(data_store)}

  context '#stats_for' do
    context 'When :short_code not exist' do
      it 'should fail' do
        resturn_value = controller_obj.stats_for(short_code)
        expect(resturn_value).to eq([
          ShortyWebApp::HTTP_STATUS[:not_found],
          controller_obj.send(:errors, 'The shortcode cannot be found in the system')
        ])
      end
    end
    context 'When :short_code exists with no visits' do
      it 'should success' do
        shortcode = short_code
        creation_time = Time.now.iso8601.to_s
        ShortyApp::CreateShorty.new(url, shortcode, data_store).perform
        resturn_value = controller_obj.stats_for(short_code)
        expect(resturn_value).to eq([
          ShortyWebApp::HTTP_STATUS[:success],
          {startDate: creation_time, redirectCount: 0}.to_json
        ])
      end
    end
    context 'When :short_code exists with visits' do
      it 'should success' do
        shortcode = short_code
        creation_time = Time.now.iso8601.to_s
        ShortyApp::CreateShorty.new(url, shortcode, data_store).perform
        visit_time = Time.now.iso8601.to_s
        ShortyApp::FindShortyUrl.new(short_code, data_store).perform
        resturn_value = controller_obj.stats_for(short_code)
        expect(resturn_value).to eq([
          ShortyWebApp::HTTP_STATUS[:success],
          {startDate: creation_time, redirectCount: 1, lastSeenDate: visit_time}.to_json
        ])
      end
    end

    context '#url_for' do
      context 'When :short_code not exist' do
        it 'should fail' do
          resturn_value = controller_obj.url_for(short_code)
          expect(resturn_value).to eq([
            ShortyWebApp::HTTP_STATUS[:not_found],
            controller_obj.send(:errors, 'The shortcode cannot be found in the system')
          ])
        end
      end
      context 'When :short_code exists' do
        it 'should success' do
          shortcode = short_code
          ShortyApp::CreateShorty.new(url, shortcode, data_store).perform
          resturn_value = controller_obj.url_for(short_code)
          expect(resturn_value).to eq([
            ShortyWebApp::HTTP_STATUS[:success],
            {url: url}.to_json
          ])
        end
      end
    end
  end
  context '#create' do
    context 'When :short_code not exist' do
      it 'should success' do
        shortcode = short_code
        resturn_value = controller_obj.create(url, shortcode)
        expect(resturn_value).to eq([
          ShortyWebApp::HTTP_STATUS[:success],
          {shortcode: shortcode}.to_json
        ])
      end
    end
    context 'When :short_code exists' do
      it 'should fail' do
        shortcode = short_code
        ShortyApp::CreateShorty.new(url, shortcode, data_store).perform
        resturn_value = controller_obj.create(url, shortcode)
        expect(resturn_value).to eq([
          ShortyWebApp::HTTP_STATUS[:conflict],
          controller_obj.send(:errors, 'The the desired shortcode is already in use')
         ])
      end
    end
    context 'When url is not exist' do
      it 'should fail' do
        resturn_value = controller_obj.create(nil, short_code)
        expect(resturn_value).to eq([
          ShortyWebApp::HTTP_STATUS[:bad_request],
          controller_obj.send(:errors, 'url is not present')
        ])
      end
    end
    context 'When :short_code provided with bad format' do
      it 'should fail' do
        resturn_value = controller_obj.create(url, '12')
        expect(resturn_value).to eq([
          ShortyWebApp::HTTP_STATUS[:unprocessable_entity],
          controller_obj.send(:errors, 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
        ])
      end
    end
    context 'When :short_code not provided' do
      it 'it shoud generate new short_code and succes' do
        resturn_value = controller_obj.create(url)
        expect(resturn_value[0]).to eq(ShortyWebApp::HTTP_STATUS[:success])
        expect(resturn_value[1]).to_not eq(nil)
      end
    end
  end
  context '#errors' do
    it 'should return hash include erros sent' do
      rand_string = SecureRandom.hex(10)
      expect(controller_obj.send(:errors, rand_string)).to eq({errors: rand_string}.to_json)
    end
  end
end
