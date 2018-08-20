require "spec_helper"

describe RedisDataStore do

  it 'should be defined' do
    expect(RedisDataStore.class).to eq(Module)
  end

  context '$redis' do
    it '$redis is defined and empty' do
      expect($redis.class).to eq(Redis)
    end
  end
end
