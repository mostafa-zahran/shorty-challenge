require "spec_helper"

describe InMemoryDataStore do

  it 'should be defined' do
    expect(InMemoryDataStore.class).to eq(Module)
  end

  context '$storage' do
    it '$storage is defined and empty' do
      expect($storage).to eq({})
    end
  end
end
