class utf_8 (
  Boolean $ensure_host  = false, #this will fail
  Boolean $ensure_users = false,
  Boolean $ensure_group = false,
  Boolean $ensure_files = false,
  Boolean $ensure_concat = false,
  String  $notify_string = 'こんにちは',
  Optional[Array] $user_array = undef,
  Optional[Hash] $file_hash = undef
)  {


  # This class is not best practises, it is for testing only.
  case $::kernel {
    'Linux': {
      $user_path = '/home/'
      $dir0  = '/メインディレクトリ/'
      $dir1 = "${dir0}ファイル＿ディレクトリ/"
      $file_owner = 'root'
      $file_group = 'root'
    }
    'Windows': {
      $user_path = 'C:\\Users\\'
      $dir0  = "C:\\メインディレクトリ\\"
      $dir1 = "${dir0}ファイル＿ディレクトリ\\"
      $file_owner = 'S-1-5-32-544'
      $file_group = 'S-1-5-32-544'
    }
    default: {
      fail("Oh, I am sorry you are using some shitty OS")
    }
  }

  File {
    owner  => $file_owner,
    group  => $file_group,
    mode   => '0644'
  }

  notify { $notify_string: }

  if $ensure_host {
    host { 'ブレット.puppet.vm':
      ensure       => present,
      ip           => '52.10.10.141',
      host_aliases => ['ブレット'],
    }
  }

  if $ensure_users and $user_array and $os['family'] != 'RedHat' {

    if $ensure_group or $ensure_users {
      group { 'オージー':
        ensure => present,
      }
    }

    $user_array.each |String $user_name| {
      user { $user_name:
        ensure  => present,
        home    => "${user_path}${user_name}",
        gid     => $os['family'] ? {
          'Windows' => undef,
          default   => "${user_name}_grp",
        },
        groups  => $os['family'] ? {
          'Windows' => ["${user_name}_grp", 'オージー'],
          default   => ['オージー'],
        },
      }

      group { "${user_name}_grp":
        ensure => present,
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

  if $ensure_files and $file_hash {

      file { [$dir0,$dir1]:
        ensure => directory
      }

      if $os['family'] == 'Windows' {
        acl { [$dir0, $dir1]:
          purge                      => false,
          permissions                => [
            { identity => $file_owner, rights => ['full'], perm_type=> 'allow', child_types => 'all', affects => 'all' },
            ],
            owner                      => $file_owner,
            group                      => $file_group,
            inherit_parent_permissions => true,
        }
      }

    $file_hash.each |String $file_name, Hash $file_hash| {

      file { "${dir0}${file_name}":
        ensure => file,
        source => 'puppet://modules/utf_8/静的',
      }

      file { "${dir1}${file_name}":
        ensure  => file,
        content => template('utf_8/テンプレート.erb'),
      }

      file { "${dir1}${file_name}_1":
        ensure  => file,
        content => $file_hash['content'],
      }

      file { "${dir0}${file_name}_test":
        ensure  => file,
        content => epp('utf_8/テンプレート.epp', { 'in_data' => $notify_string }),
      }

      if $os['family'] == 'Windows' {
        acl { ["${dir0}${file_name}", "${dir1}${file_name}", "${dir1}${file_name}_1", "${dir0}${file_name}_test"]:
          purge                      => false,
          permissions                => [
            { identity => $file_owner, rights => ['full'], perm_type=> 'allow', child_types => 'all', affects => 'all' },
            ],
            owner                      => $file_owner,
            group                      => $file_group,
            inherit_parent_permissions => true,
        }
      }
    }
  }

  if $ensure_concat {
    concat { "${dir0}醸造所":
      ensure => present,
    }

    concat::fragment { 'Brett':
      target  => "${dir0}醸造所",
      content => 'ブレット',
      order   => '01',
    }

    concat::fragment { 'Jesse':
      target  => "${dir0}醸造所",
      content => 'ジェシー',
      order   => '02',
    }

    concat::fragment { 'Dylan':
      target  => "${dir0}醸造所",
      content => 'ディラン',
      order   => '03',
    }
  }
}
