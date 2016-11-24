require 'spec_helper'

describe 'marc_ext' do
  include_context 'shared_data'
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

  describe 'support functions' do
    it 'lists all tags of record' do
      expect(marc.tags).to match_array %w(001 005 100 101 200 210 215 606 701 712 801 911)
    end

    context 'controlfields' do
      let(:subject) { marc.controlfields }

      it 'is an Array' do
        expect(subject).to be_an Array
      end

      it 'contains only controlfields' do
        expect(subject.size).to eq 2
        expect(subject[0].tag).to eq '001'
        expect(subject[1].tag).to eq '005'
      end
    end

    context 'datafields' do
      let(:subject) { marc.datafields }

      it 'is an Hash' do
        expect(subject).to be_an Hash
      end
      it 'is grouped by field tag' do
        expect(subject.keys).to match_array %w(100 101 200 210 215 606 701 712 801 911)
        expect(subject['701'].size).to eq 2
      end
    end

    context 'djson' do
      context 'leader' do
        it 'returns control number and the leader' do
          k = { '1' => marc.leader }
          expect(marc.leader_to_djson).to eq k.to_json
        end
      end

      context 'controlfield' do
        it 'returns control number and the value of field' do
          k = { '1' => marc['005'].value }
          expect(marc.to_djson('005')).to eq k.to_json
        end
      end

      context 'datafield' do
        it 'returns the right json' do
          k = { '1' => { 'count' => 1, :fields => [ { ind: '  ', count: { 'a' => 1}, subfields: [{ 'a' => '19991022d        |||y0Grey50      ba'}]}]}}
          expect(marc.to_djson('100')).to eq k.to_json
          p marc.to_djson('701')
        end
      end
    end

    context 'yield djson' do
      it 'yields all record parts' do
        marc.each_part_in_djson do |tag, part|
          p "#{tag} ---> #{part}"
        end
      end
    end
  end
end
