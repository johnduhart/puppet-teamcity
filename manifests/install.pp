class teamcity::install (
  $version     = $teamcity::version,
  $product     = $teamcity::product,
  $format      = $teamcity::format,
  $installdir  = $teamcity::installdir,
  $datadir     = $teamcity::datadir,
  $user        = $teamcity::user,
  $group       = $teamcity::group,
  $downloadURL = $teamcity::downloadURL,

  $webappdir
) {
  group { $group:
    ensure => present,
  } ->
  user { $user:
    comment          => 'TeamCity daemon account',
    shell            => '/bin/bash',
    home             => $datadir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  }

  if ! defined(File[$installdir]) {
    file { $installdir:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }
  }

  require staging
  $file = "TeamCity-${version}.${format}"
  if ! defined(File[$webappdir]) {
    file { $webappdir:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }
  }
  staging::file { $file:
    source  => "${downloadURL}/${file}",
    timeout => 1800,
  } ->
  staging::extract { $file:
    target  => $webappdir,
    creates => "${webappdir}/conf",
    strip   => 1,
    user    => $user,
    group   => $group,
    notify  => Exec["chown_${webappdir}"],
    before  => File[$datadir],
    require => [
      File[$installdir],
      User[$user],
      File[$webappdir] ],
  }

  file { $datadir:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    require => User[$user],
  } ->

  exec { "chown_${webappdir}":
    command     => "/bin/chown -R ${user}:${group} ${webappdir}",
    refreshonly => true,
    subscribe   => User[$teamcity::user]
  }
}