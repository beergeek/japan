class japan (
  Boolean $ensure_host  = false, #this will fail
  Boolean $ensure_users = true,
  Boolean $ensure_group = true,
  Boolean $ensure_files = true,
  Optional[Array] $user_array   = undef
)  {


  # This class is not best practises, it is for testing only.
  case $::kernel {
    'Linux': {
      $user_path = '/home/'
      $user_gid  = 'オージー'
      $user_groups = undef
      $dir0  = '/メインディレクトリ/'
      $file_owner = 'root'
      $file_group = 'root'
    }
    'Windows': {
      $user_path = 'C:\\Users\\'
      $user_gid  = undef
      $user_groups = 'オージー'
      $dir0  = "C:\\メインディレクトリ\\"
      $file_owner = 'Administrator'
      $file_group = 'Administrators'
    }
    default: {
      fail("Oh, I am sorry you are using some shitty OS")
    }
  }
  $file0 = '静的'
  $file1 = 'テンプレート'

  File {
    owner  => $file_owner,
    group  => $file_group,
    mode   => '0644'
  }

  notify { 'こんにちは': }

  if $enable_host {
    host { 'ブレット.puppet.vm':
      ensure       => present,
      ip           => '52.10.10.141',
      host_aliases => ['ブレット'],
    }
  }

  if $enable_users and $user_array {
    $user_array.each |String $user_name| {
      user { $user_name:
        ensure  => present,
        home    => "${user_path}${user_name}",
        gid     => $user_gid,
        groups  => $user_groups,
      }

      file { "${user_path}${user_name}":
        ensure => directory,
        owner  => $user_name,
        group  => $user_name,
        mode   => '0700',
      }

      #if $os['family'] == 'Windows' {
      #  acl { "${user_path}${user_name}":
      #    purge                      => false,
      #    permissions                => [
      #      { identity => $user_name, rights => ['full'], perm_type=> 'allow', child_types => 'all', affects => 'all' },
      #      ],
      #      owner                      => $user_name,
      #      group                      => $user_name,
      #      inherit_parent_permissions => false,
      #  }
      #}
    }
  }

  if $ensure_group or $ensure_users {
    group { 'オージー':
      ensure => present,
    }
  }

  if $ensure_files {
    file { $dir0:
      ensure => directory
    }

    file { "${dir0}${file0}":
      ensure => file,
      source => 'puppet://modules/japan/静的',
    }

    file { "${dir0}${file1}":
      ensure  => file,
      content => template('japan/テンプレート.erb'),
    }

    file { "${dir0}test":
      ensure  => file,
      content => epp('japan/テンプレート.epp'),
    }

    #if $os['family'] == 'Windows' {
    #  acl { [$dir0, "${dir0}${file0}", "${dir0}${file1}", "${dir0}test"]:
    #    purge                      => false,
    #    permissions                => [
    #      { identity => $user_name, rights => ['full'], perm_type=> 'allow', child_types => 'all', affects => 'all' },
    #      ],
    #      owner                      => $file_owner,
    #      group                      => $File_group,
    #      inherit_parent_permissions => true,
    #  }
    #}
  }
}
