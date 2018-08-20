require "spec_helper"

describe ShortyApp::ShortyException do

  it 'should be defined' do
    expect(ShortyApp::ShortyException.class).to eq(Module)
  end

  context 'test included classes' do

    def test_exception_class(class_name)
      expect(class_name.class).to eq(Class)
      expect(class_name.superclass).to eq(RuntimeError)
    end

    it 'UrlNotPresent is defined and inherte from RuntimeError' do
      test_exception_class(ShortyApp::ShortyException::UrlNotPresent)
    end

    it 'ShortCodeBadFormat is defined and inherte from RuntimeError' do
      test_exception_class(ShortyApp::ShortyException::ShortCodeBadFormat)
    end

    it 'ShortCodeInUse is defined and inherte from RuntimeError' do
      test_exception_class(ShortyApp::ShortyException::ShortCodeInUse)
    end

    it 'ShortyException is defined and inherte from RuntimeError' do
      test_exception_class(ShortyApp::ShortyException::ShortCodeInUse)
    end
  end
end
