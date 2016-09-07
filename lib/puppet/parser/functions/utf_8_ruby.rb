module Puppet::Parser::Functions
  newfunction(:write_line_to_file, :type => :rvalue) do |args|
    value ||= 'アパッチ族'
    "#{value} ruby function works"
  end
end
