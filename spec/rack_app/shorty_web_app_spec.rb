require "spec_helper"

describe ShortyWebApp do

  it 'should be defined' do
    expect(ShortyWebApp.class).to eq(Module)
    expect(ShortyWebApp.const_get(:HTTP_STATUS)).to eq({
    success: 200,
    bad_request: 400,
    not_found: 404,
    unprocessable_entity: 422,
    conflict: 409
  })
  end
end
