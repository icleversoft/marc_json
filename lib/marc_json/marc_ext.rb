require 'marc'

module MARCJson
  class MARC::DataField
    def to_json
      [indicators_as_string].concat(subfields_as_arrays)
    end

    def indicators_as_string
      [indicator1, indicator2].join
    end

    def subfields_as_arrays
      subfields.map{|s| s.to_json}
    end
  end

  class MARC::Subfield
    def to_json
      [code, value]
    end
  end
end

