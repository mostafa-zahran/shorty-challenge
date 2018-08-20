require "spec_helper"
require 'json'
require 'securerandom'

describe ShortyWebApp::Dispatcher do

  it 'should be defined' do
    expect(ShortyWebApp::Dispatcher.class).to eq(Class)
  end
  context 'Dispatcher behaviour' do

    def parse_response(response)
      {
        status: response[0],
        header: response[1],
        body: JSON.parse(response[2].first)
      }
    end
    let!(:json_header) {{'Content-Type' => 'application/json'}}
    let!(:url){'google.com'}
    let!(:dispatcher_obj){ShortyWebApp::Dispatcher.new}
    let(:short_code) {SecureRandom.urlsafe_base64(4).tr('-', '_')}

    context 'GET /:short_code' do
      def send_request(short_code)
        env = Rack::MockRequest.env_for("http://example.com:8080/#{short_code}")
        parse_response(ShortyWebApp::Dispatcher.new.call(env))
      end
      context 'When :short_code not exist' do
        it 'should fail' do
          response = send_request(short_code)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:not_found])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['errors']).to eq('The shortcode cannot be found in the system')
        end
      end
      context 'When :short_code exists' do
        it 'should success' do
          shortcode = short_code
          ShortyApp::CreateShorty.new(url, shortcode, dispatcher_obj.send(:data_store)).perform
          response = send_request(shortcode)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:success])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['url']).to eq(url)
        end
      end
    end

    context 'GET /:short_code/stats' do
      def send_request(short_code)
        env = Rack::MockRequest.env_for("http://example.com:8080/#{short_code}/stats")
        parse_response(ShortyWebApp::Dispatcher.new.call(env))
      end
      context 'When :short_code not exist' do
        it 'should fail' do
          response = send_request(short_code)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:not_found])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['errors']).to eq('The shortcode cannot be found in the system')
        end
      end
      context 'When :short_code exists with no visits' do
        it 'should success' do
          shortcode = short_code
          creation_time = Time.now.iso8601.to_s
          ShortyApp::CreateShorty.new(url, shortcode, dispatcher_obj.send(:data_store)).perform
          response = send_request(shortcode)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:success])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['startDate']).to eq(creation_time)
          expect(response[:body]['redirectCount']).to eq(0)
          expect(response[:body]['lastSeenDate']).to eq(nil)
        end
      end

      context 'When :short_code exists with visits' do
        it 'should success' do
          shortcode = short_code
          creation_time = Time.now.iso8601.to_s
          ShortyApp::CreateShorty.new(url, shortcode, dispatcher_obj.send(:data_store)).perform
          visit_time = Time.now.iso8601.to_s
          ShortyApp::FindShortyUrl.new(short_code, dispatcher_obj.send(:data_store)).perform
          response = send_request(shortcode)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:success])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['startDate']).to eq(creation_time)
          expect(response[:body]['redirectCount']).to eq(1)
          expect(response[:body]['lastSeenDate']).to eq(visit_time)
        end
      end
    end

    context 'POST /shorten' do
      def send_request(short_code, add_url = true)
        env = Rack::MockRequest.env_for("http://example.com:8080/shorten",
          {"REQUEST_METHOD" => 'POST', 'CONTENT_TYPE' => 'application/json',  input: {url: add_url ? url : nil, shortcode: short_code}.to_json})
        parse_response(ShortyWebApp::Dispatcher.new.call(env))
      end
      context 'When :short_code not exist' do
        it 'should success' do
          response = send_request(short_code)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:success])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['shortcode']).to eq(short_code)
        end
      end
      context 'When :short_code exists' do
        it 'should fail' do
          shortcode = short_code
          ShortyApp::CreateShorty.new(url, shortcode, dispatcher_obj.send(:data_store)).perform
          response = send_request(shortcode)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:conflict])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['errors']).to eq('The the desired shortcode is already in use')
        end
      end
      context 'When url is not exist' do
        it 'should fail' do
          response = send_request(short_code, false)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:bad_request])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['errors']).to eq('url is not present')
        end
      end
      context 'When :short_code provided with bad format' do
        it 'should fail' do
          shortcode = '12'
          response = send_request(shortcode)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:unprocessable_entity])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['errors']).to eq('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
        end
      end
      context 'When :short_code not provided' do
        it 'it shoud generate new short_code and succes' do
          response = send_request(nil)
          expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:success])
          expect(response[:header]).to eq(json_header)
          expect(response[:body]['shortcode']).to_not eq(nil)
        end
      end
    end
    context '#DELETE' do
      def send_request
        env = Rack::MockRequest.env_for("http://example.com:8080/", {"REQUEST_METHOD" => 'DELETE'})
        parse_response(ShortyWebApp::Dispatcher.new.call(env))
      end
      it 'should fail' do
        response = send_request
        expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:bad_request])
        expect(response[:header]).to eq(json_header)
        expect(response[:body]['errors']).to eq('Bad Request')
      end
    end

    context '#PUT' do
      def send_request
        env = Rack::MockRequest.env_for("http://example.com:8080/", {"REQUEST_METHOD" => 'PUT'})
        parse_response(ShortyWebApp::Dispatcher.new.call(env))
      end
      it 'should fail' do
        response = send_request
        expect(response[:status]).to eq(ShortyWebApp::HTTP_STATUS[:bad_request])
        expect(response[:header]).to eq(json_header)
        expect(response[:body]['errors']).to eq('Bad Request')
      end
    end
  end
end
