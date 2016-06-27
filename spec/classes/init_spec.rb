require 'spec_helper'
describe 'utf_8' do

  context "fails on non-Linux or non-Windoz" do
    let(:facts) {
      {
        'kernel' => 'Gigantic_Brewery',
      }
    }

    it 'is_expected.to explode' do
      expect { catalogue }.to raise_error(Puppet::Error, /Oh, I am sorry you are using some shitty OS/)
    end
  end

  context 'all defaults' do
    let(:facts) {
      {
        'kernel' => 'Linux',
      }
    }
    it { is_expected.to contain_class('utf_8') }
    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_notify('こんにちは')
    }
  end

  context 'with host ensured' do
    let(:facts) {
      {
        'kernel' => 'Linux',
      }
    }
    let(:params) {
      {
        'ensure_host' => true,
      }
    }

    # THIS WILL ACTUALLY FAIL ON THE NODE!
    it {
      is_expected.to contain_host('ブレット.puppet.vm')
    }
  end

  context '' do
    let(:facts) {
      {
        'kernel' => 'Linux',
        'os'     => { 'family' => 'debian' },
      }
    }
    let(:params) {
      {
        'user_array'   => ["ブレット", "ディラン", "ジェシー"],
        'ensure_users' => true,
      }
    }

    it {
      is_expected.to contain_group('オージー')
    }

    it {
      is_expected.to contain_user('ブレット').with({
        'ensure' => 'present',
        'home'   => '/home/ブレット',
        'gid'    => 'ブレット_grp',
        'groups' => ['オージー'],
      })
    }

    it {
      is_expected.to contain_group('ブレット_grp')
    }

    it {
      is_expected.to contain_file('/home/ブレット').with({
        'ensure' => 'directory',
        'owner'  => 'ブレット',
        'group'  => 'ブレット',
        'mode'   => '0700',
      })
    }

    it {
      is_expected.to contain_user('ディラン').with({
        'ensure' => 'present',
        'home'   => '/home/ディラン',
        'gid'    => 'ディラン_grp',
        'groups' => ['オージー'],
      })
    }

    it {
      is_expected.to contain_group('ディラン_grp')
    }

    it {
      is_expected.to contain_file('/home/ディラン').with({
        'ensure' => 'directory',
        'owner'  => 'ディラン',
        'group'  => 'ディラン',
        'mode'   => '0700',
      })
    }

    it {
      is_expected.to contain_user('ジェシー').with({
        'ensure' => 'present',
        'home'   => '/home/ジェシー',
        'gid'    => 'ジェシー_grp',
        'groups' => ['オージー'],
      })
    }

    it {
      is_expected.to contain_group('ジェシー_grp')
    }

    it {
      is_expected.to contain_file('/home/ジェシー').with({
        'ensure' => 'directory',
        'owner'  => 'ジェシー',
        'group'  => 'ジェシー',
        'mode'   => '0700',
      })
    }
  end

  context 'files on Linux' do
    let(:facts) {
      {
        'kernel'      => 'Linux',
        'data_centre' => '東京',
        'os'          => { 'family' => 'RedHat', },
      }
    }
    let(:params) {
      {
        'ensure_files' => true,
        'file_hash'    => {"ファイル＿2"=>{"content"=>"ブレット"}, "ファイル＿3"=>{"content"=>"ディラン"}},
      }
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/').with({
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/ファイル＿ディレクトリ/').with({
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/ファイル＿2').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet://modules/utf_8/静的',
      })
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/ファイル＿ディレクトリ/ファイル＿2').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      }).with_content(/.*東京.*/)
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/ファイル＿ディレクトリ/ファイル＿2_1').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content'  => 'ブレット',
      })
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/ファイル＿3').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet://modules/utf_8/静的',
      })
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/ファイル＿ディレクトリ/ファイル＿3').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      }).with_content(/\s*東京\s*/)
    }

    it {
      is_expected.to contain_file('/メインディレクトリ/ファイル＿ディレクトリ/ファイル＿3_1').with({
        'ensure'  => 'file',
        'content'  => 'ディラン',
      })
    }

  end

  context 'files on Windows' do
    let(:facts) {
      {
        'kernel'      => 'Windows',
        'data_centre' => '東京',
        'os'          => { 'family' => 'Windows', },
      }
    }
    let(:params) {
      {
        'ensure_files' => true,
        'file_hash'    => {"ファイル＿2"=>{"content"=>"ブレット"}, "ファイル＿3"=>{"content"=>"ディラン"}},
      }
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\").with({
        'ensure'  => 'directory',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
      })
    }

    it {
      is_expected.to contain_acl('C:\\メインディレクトリ\\').with({
        'purge'                      => false,
        'permissions'                => [
        {
          'identity'                  => 'S-1-5-32-544',
          'rights'                    => ['full'],
          'perm_type'                 => 'allow',
          'child_types'               => 'all',
          'affects'                   => 'all'
        },
        ],
        'owner'                      => 'S-1-5-32-544',
        'group'                      => 'S-1-5-32-544',
        'inherit_parent_permissions' => true,
      })
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿ディレクトリ\\").with({
        'ensure'  => 'directory',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
      })
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿2").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
        'source'  => 'puppet://modules/utf_8/静的',
      })
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿ディレクトリ\\/ファイル＿2").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
      }).with_content(/.*東京.*/)
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿ディレクトリ\\/ファイル＿2_1").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
        'content'  => 'ブレット',
      })
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿ディレクトリ\\/ファイル＿2_test").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
      }).with_content(/\s*東京\s*/)
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿3").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
        'source'  => 'puppet://modules/utf_8/静的',
      })
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿ディレクトリ\\/ファイル＿3").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
      }).with_content(/\s*東京\s*/)
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿ディレクトリ\\/ファイル＿3_1").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'content'  => 'ディラン',
      })
    }

    it {
      is_expected.to contain_file("C:\\メインディレクトリ\\ファイル＿ディレクトリ\\/ファイル＿3_test").with({
        'ensure'  => 'file',
        'owner'   => 'S-1-5-32-544',
        'group'   => 'S-1-5-32-544',
        'mode'    => '0644',
      }).with_content(/\s*東京\s*/)
    }
  end
end
