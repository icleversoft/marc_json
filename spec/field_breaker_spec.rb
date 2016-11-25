require 'spec_helper'

describe 'FieldBreaker' do
  let(:marc) { MARC::Reader.new(File.join(File.dirname(__FILE__), 'support/data/1.mrc')) }

  it 'breaks a record to fields in json files' do
    MARCJson::FieldBreaker.new(marc).execute!
  end

end

