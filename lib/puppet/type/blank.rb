Puppet::Type.newtype :blank, :is_capability => true do
  newparam :message, :is_namevar => true
end
