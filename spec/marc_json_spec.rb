require 'spec_helper'

describe MARCJson do
  include_context 'shared_data'
  it 'has a version number' do
    expect(MARCJson::VERSION).not_to be nil
  end

  it 'converts a marc record to json' do
    m = MARCJson::Renderer.new( marc )
    expect(m.to_json).to eq(json)
  end

  it 'converts a json back to marc record' do
    m = MARCJson::Reader.new( json )
    expect(m.to_marc).to eq marc
  end
end
