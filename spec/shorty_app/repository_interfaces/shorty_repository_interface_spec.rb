require "spec_helper"

describe ShortyApp::ShortRepositoryInterface do

  it 'should be defined' do
    expect(ShortyApp::ShortRepositoryInterface.class).to eq(Module)
  end

  context 'test class behaviour included ShortRepositoryInterface' do
    let!(:dummy_class) { Class.new { include ShortyApp::ShortRepositoryInterface } }
    let!(:dummy_obj) {dummy_class.new}
    context '#create!' do
      it 'should have create! method' do
        expect(dummy_obj.respond_to?(:create!)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{dummy_obj.create!({})}.to raise_exception(NotImplementedError)
      end
    end

    context '#find' do
      it 'should have find method' do
        expect(dummy_obj.respond_to?(:find)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{dummy_obj.find('')}.to raise_exception(NotImplementedError)
      end
    end

    context '#exists?' do
      it 'should have exists? method' do
        expect(dummy_obj.respond_to?(:exists?)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{dummy_obj.exists?('')}.to raise_exception(NotImplementedError)
      end
    end

    context '#save!' do
      it 'should have save! method' do
        expect(dummy_obj.respond_to?(:save!)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{dummy_obj.save!('')}.to raise_exception(NotImplementedError)
      end
    end
  end

  context 'test ShortRepositoryInterface behaviour' do
    context '#create!' do
      it 'should have create! method' do
        expect(ShortyApp::ShortRepositoryInterface.respond_to?(:create!)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{ShortyApp::ShortRepositoryInterface.create!({})}.to raise_exception(NotImplementedError)
      end
    end

    context '#find' do
      it 'should have find method' do
        expect(ShortyApp::ShortRepositoryInterface.respond_to?(:find)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{ShortyApp::ShortRepositoryInterface.find('')}.to raise_exception(NotImplementedError)
      end
    end

    context '#exists?' do
      it 'should have exists? method' do
        expect(ShortyApp::ShortRepositoryInterface.respond_to?(:exists?)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{ShortyApp::ShortRepositoryInterface.exists?('')}.to raise_exception(NotImplementedError)
      end
    end

    context '#save!' do
      it 'should have save! method' do
        expect(ShortyApp::ShortRepositoryInterface.respond_to?(:save!)).to eq(true)
      end

      it 'should raise NotImplementedError when call it' do
        expect{ShortyApp::ShortRepositoryInterface.save!('')}.to raise_exception(NotImplementedError)
      end
    end
  end
end
