require 'spec_helper'
require 'json'
shared_context "shared_data" do
  let(:marc){MARC::Reader.new(File.join(File.dirname(__FILE__), 'data/1.mrc')).first}
  let(:json){JSON.parse(File.open(File.join(File.dirname(__FILE__), 'data/1.json')).read)}
end
