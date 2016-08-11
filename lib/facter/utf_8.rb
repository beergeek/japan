x = "\u00A1"
y = "\uFFFF"
(x...y).each do |a|
  Facter.add("#{a.encode('utf-8')}#{a.next.encode('utf-8')}") do
    setcode do
      z = "#{a.encode('utf-8')}#{a.next.encode('utf-8')}"
    end
  end
end
