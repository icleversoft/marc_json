module MARCJson
  class Reader
    def initialize( json_data = {} )
      @marc = MARC::Record.new
      to_hash( json_data )
      build_record
    end

    def to_marc
      @marc
    end


    private
    def build_record
      unless @json.empty?
        @marc.leader = @json.delete("000")
        @json.each{|t, v| @marc.append_tag_value(t, v)} 
      end
    end

    def to_hash( json_data )
      @json = json_data.is_a?(Hash) ? json_data : JSON.parse( json_data )
    rescue 
      @json = {}
    end
  end
end
