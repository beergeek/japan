Puppet::Type.newtype :blank, :is_capability => true do
  newparam :message, :namevar => true
end
