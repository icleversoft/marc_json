module MARCJson
  class FieldBreaker
    def initialize(marc)
      @marc = marc
      @files = []
    end

    def execute!(path=nil)
      @marc.each do |record|
        record.each_part_in_djson do |tag, value|
          fname = path ? File.join(path, "#{tag}.json") : "#{tag}.json"
          unless File.exist?(fname)
            out = File.open(fname, 'a+')
            out.write("{\n")
            comma = "\n"
          else
            out = File.open(fname, 'a+')
            comma = ",\n"
          end
          value = value.is_a?(String) ? "\"#{value}\"" : value.to_json
          out.write("\"#{record.record_no}\":#{value}#{comma}")
          out.close
          @files << fname unless @files.include?(fname)
        end
      end
      @files.each do |file|
        File.open(file, 'a+') do |f|
          f.write('}')
        end
      end
    end
  end
end
