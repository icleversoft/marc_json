require "marc_json/version"
require 'marc_json/marc_ext'
require 'json'

module MARCJson
  class Renderer
    include MARC
    def initialize( marc )
      throw ArgumentError.new("Record should be a MARC::Record instance") unless marc.is_a? MARC::Record
      @data = {}
      @data["000"] = marc.leader
      process_fields( marc.fields  )
    end

    def to_json
      @data
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

  class Reader
    include MARC
    def initialize( json_data = {} )
      @marc = Record.new
      build_record if json_is_valid?( json_data )
    end

    def to_marc
      @marc
    end


   private
   def build_record
     @marc.leader = @json.delete("000")
     @json.each{|t, v| @marc.append_tag_value(t, v)}
   end

   def json_is_valid?( json_data )
     ret_val = false
     begin
       @json = json_data.is_a?(Hash) ? json_data : JSON.parse( json_data )
       ret_val = true
     rescue => e
       @json = {}
     end
     ret_val
   end
  end
end
