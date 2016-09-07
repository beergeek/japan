# encoding: utf-8
module Puppet::Parser::Functions
  newfunction(:utf_8_ruby, :type => :rvalue) do |args|
    value = args[0]
    value ||= 'アパッチ族'
    "#{value} ruby function works"
  end
end
