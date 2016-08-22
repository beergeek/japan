class utf_8::puppet_users (
  $user_hash,
)  {

  # just skip over if not Linux
  if $::kernel != 'Linux' {
    fail("This class is only for Linux nodes")
  }

  $user_hash.each |String $user_key, Hash $user_values| {

    if $user_values['manage_user'] == true {
      user { $user_key:
        ensure => present,
        home   => "/home/${user_key}",
      }
    }

    file { "/home/${user_key}":
      ensure => directory,
      owner  => $user_key,
      group  => $user_key,
      mode   => '0700',
    }

    file { ["/home/${user_key}/.puppetlabs","/home/${user_key}/.puppetlabs/etc","/home/${user_key}/.puppetlabs/etc/puppet"]:
      ensure => directory,
      owner  => $user_key,
      group  => $user_key,
      mode   => '0755',
    }


    file { "/home/${user_key}/.puppetlabs/etc/puppet/puppet.conf":
      ensure => file,
      owner  => $user_key,
      group  => $user_key,
      mode   => '0644',
    }

    pe_ini_setting { "${user_values['ascii_name']}_certificate":
      ensure  => present,
      setting => 'certname',
      value   => "${user_values['ascii_name']}_${::hostname}",
      path    => "/home/${user_key}/.puppetlabs/etc/puppet/puppet.conf",
      section => 'agent',
      require => File["/home/${user_key}/.puppetlabs/etc/puppet/puppet.conf"],
    }

    pe_ini_setting { "${user_values['ascii_name']}_user":
      ensure  => present,
      setting => 'user',
      value   => $user_key,
      path    => "/home/${user_key}/.puppetlabs/etc/puppet/puppet.conf",
      section => 'agent',
      require => File["/home/${user_key}/.puppetlabs/etc/puppet/puppet.conf"],
    }

    pe_ini_setting { "${user_values['ascii_name']}_server":
      ensure  => present,
      setting => 'server',
      value   => $::settings::server,
      path    => "/home/${user_key}/.puppetlabs/etc/puppet/puppet.conf",
      section => 'agent',
      require => File["/home/${user_key}/.puppetlabs/etc/puppet/puppet.conf"],
    }

    cron { "${user_key}_puppet":
      ensure  => present,
      command => '/opt/puppetlabs/bin/puppet agent -t',
      minute  => '*/10',
      user    => $user_key,
      require => [User[$user_key],Pe_ini_setting["${user_values['ascii_name']}_certificate","${user_values['ascii_name']}_user","${user_values['ascii_name']}_server"]],
    }
  }
}
