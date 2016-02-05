require 'spec_helper'

describe 'marc_ext' do
  context 'subfield' do
    it 'returns an array' do
      subfield = MARC::Subfield.new('a', 'value')
      expect(subfield.to_fjson).to eq ['a', 'value']
    end
    it 'returns nil if value is empty' do
      subfield = MARC::Subfield.new('a', ' ')
      expect(subfield.to_fjson).to eq nil
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

    it "does not contain any subfields" do
      datafield1 = MARC::DataField.new('100', '1', '2', ['a', 'Subfield a'], ['b', ' '])
      expect(datafield1.subfields_as_arrays).to eq [['a', 'Subfield a']]
    end

    it "returns a json" do
      expect(datafield.to_fjson).to eq ['12', ['a', 'Subfield a'], ['b', 'Subfield b']]
    end
  end

end
