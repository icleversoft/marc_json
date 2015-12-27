module MARCJson
  class Renderer
    include MARC
    def initialize( marc )
      throw ArgumentError.new("Record should be a MARC::Record instance") unless marc.is_a? MARC::Record
      @data = {}
      @data["000"] = marc.leader
      process_fields( marc.fields  )
    end

    def to_hash
      @data
    end

    def to_json
      @data.to_json
    end

    private
    def process_fields( fields )
      fields.each(&field_processor)
    end

    def field_processor
      ->(field){field.is_a?(ControlField) ? controlfield( field ) : datafield( field )}
    end

    def controlfield( field )
      @data[field.tag] = field.value
    end

    def datafield( field )
      @data[field.tag] ||= []
      @data[field.tag] << field.to_json 
    end
  end
end
