require 'spec_helper'

describe 'marc_ext' do
  context 'subfield' do
    let(:subfield){MARC::Subfield.new('a', 'value')}
    it 'returns an array' do
      expect(subfield.to_fjson).to eq ['a', 'value']
    end
  end
  context 'datafield' do
    let(:datafield){MARC::DataField.new('100', '1', '2', ['a', 'Subfield a'], ['b', 'Subfield b'])}
    it "returns indicators as string" do
      expect(datafield.indicators_as_string).to eq '12'
    end

    it "returns subfields in array" do
      expect(datafield.subfields_as_arrays).to eq [['a', 'Subfield a'], ['b', 'Subfield b']]
    end

    it "returns a json" do
      expect(datafield.to_fjson).to eq ['12', ['a', 'Subfield a'], ['b', 'Subfield b']]
    end
  end

end
