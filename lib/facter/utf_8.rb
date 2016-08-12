# encoding: utf-8
Facter.add(:utf_8) do
  setcode do
    z = Hash.new
    (12...255).each do |a|
      z.merge!("#{a.ord.to_s(16)}" => "#{[a.ord.to_s(16).hex].pack('U').encode('utf-8')}")
    end
    (1872...1919).each do |a|
      z.merge!("#{a.ord.to_s(16)}" => "#{[a.ord.to_s(16).hex].pack('U').encode('utf-8')}")
    end
    (12352...12447).each do |a|
      z.merge!("#{a.ord.to_s(16)}" => "#{[a.ord.to_s(16).hex].pack('U').encode('utf-8')}")
    end
    z
  end
end
