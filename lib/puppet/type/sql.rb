Puppet::Type.newtype :sql, :is_capability => true do
  newparam :name, :is_namevar => true
  newparam :user
  newparam :password
  newparam :host
  newparam :port do
    defaultto :standard
    newvalues(:standard, /^\d+$/)
  end
  newparam :database
  newparam :type do
    newvalues(:mysql, :postgresql)
  end
end
