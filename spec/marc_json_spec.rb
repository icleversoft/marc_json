require 'spec_helper'
require 'marc'

describe MARCJson do
  include_context 'shared_data'
  it 'has a version number' do
    expect(MARCJson::VERSION).not_to be nil
  end

  it 'converts a marc record to hash' do
    m = MARCJson::Renderer.new( marc )
    expect(m.to_hash).to eq(json)
  end

  context '#to_json' do
    let(:rec){ MARCJson::Renderer.new( marc ) }
    it 'is a string' do
      expect(rec.to_json).to be_an String
    end

    it 'is a valid json' do
      expect(JSON.parse(rec.to_json)).to be_an Hash
    end

    it 'contains the valid content' do
      expect(JSON.parse(rec.to_json)).to eq( json )
    end

  end

  it 'converts a hash back to marc record' do
    m = MARCJson::Reader.new( json )
    expect(m.to_marc).to eq marc
  end

  it 'converts a json string to marc record' do
    m = MARCJson::Reader.new( json.to_json )
    expect(m.to_marc).to eq marc
  end

  it 'returns an empty marc record when json is invalid' do
    m = MARCJson::Reader.new( "blalbdx" )
    expect(m.to_marc).to eq MARC::Record.new 
  end

end
