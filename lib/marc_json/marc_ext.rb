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
      subfields.map{|s| s.to_fjson}
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
      [code, value]
    end
  end


  class MARC::Record
    def append_tag_value( tag, value )
      if value.is_a? String
        append( controlfield_from_pair( tag, value ) )
      else
        value.each do |v|
          append( datafield_from_pair(tag, v) )
        end
      end
    end
    private
    def controlfield_from_pair( tag, value )
      MARC::ControlField.new( tag, value )
    end

    def datafield_from_pair( tag, value )
      MARC::DataField.from_tag_array(tag, value)
    end
  end
end

