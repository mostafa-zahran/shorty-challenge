require "spec_helper"

describe ShortyApp::RepositoryInterface do

  it 'should be defined' do
    expect(ShortyApp::RepositoryInterface.class).to eq(Module)
  end

  context 'test class behaviour included RepositoryInterface module' do
    let!(:dummy_class) { Class.new { include ShortyApp::RepositoryInterface } }
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
end
