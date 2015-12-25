require 'spec_helper'

describe 'marc_ext' do
  context 'datafield' do
    let(:datafield){MARC::DataField.new('100', '1', '2', ['a', 'Subfield a'], ['b', 'Subfield b'])}
    it "return indicators as string" do
      expect(datafield.indicators_as_string).to eq '12'
    end
    
    it "return subfields in array" do
      expect(datafield.subfields_as_arrays).to eq [['a', 'Subfield a'], ['b', 'Subfield b']]
    end

  end

end
