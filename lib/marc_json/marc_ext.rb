require 'marc'

module MARCJson

  class MARC::DataField
    def to_fjson
      [indicators_as_string].concat(subfields_as_arrays)
    end

    def indicators_as_string
      [indicator1, indicator2].join
    end

    def subfields_as_arrays
      subfields.map{|s| s.to_fjson}.delete_if{|i| i.nil?}
    end

    def subfield_hashes
      ->(subfield){ { subfield.code => subfield.value } }
    end

    def to_djson
      {
              ind: indicators_as_string,
            count: subfields_stats,
        subfields: subfields.map(&subfield_hashes)
      }
    end

    def subfields_stats
      ret_val = {}
      subfields.each do |subfield|
        k = ret_val[subfield.code] || 0
        ret_val[subfield.code] = k + 1
      end
      ret_val
    end

    class << self

      def from_tag_array(tag, arr)
        indicators = arr.delete_at( 0 )
        MARC::DataField.new( tag, indicators[0], indicators[1], *arr )
      end
    end

  end

  class MARC::Subfield
    def to_fjson
      stripped_value.empty? ? nil : [code, stripped_value]
    end

    def stripped_value
      value.strip
    end
  end


  class MARC::Record
    def each_part_in_djson
      yield 'LDR', leader
      tags.each do |tag|
        yield tag, to_djson(tag)
      end
    end

    def to_djson(tag)
      (self[tag] ? djson_for_field(self[tag]) : {})
    end

    def append_tag_value( tag, value )
      if value.is_a? String
        append( controlfield_from_pair( tag, value ) )
      else
        value.each do |v|
          append( datafield_from_pair(tag, v) )
        end
      end
    end

    def controlfields
      fields.select{ |field| field.is_a?(MARC::ControlField) }
    end

    def datafields
      fields.select{ |field| field.is_a?(MARC::DataField) }.group_by(&:tag)
    end

    def record_no
      (self['001'] ? self['001'].value : Time.current.to_i).to_s
    end

    private

    def djson_for_field(field)
      field.is_a?(MARC::ControlField) ? field.value :  djson_for_datafield(field)
    end

    def djson_for_datafield(field)
      dfields = datafields[field.tag]
      { count: dfields.size, fields: dfields.collect{ |field| field.to_djson } }
    end

    def controlfield_from_pair( tag, value )
      MARC::ControlField.new( tag, value )
    end

    def datafield_from_pair( tag, value )
      MARC::DataField.from_tag_array(tag, value)
    end
  end
end

