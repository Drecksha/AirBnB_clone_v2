# Define a class for setting up web_static
class setup_web_static {
  
  # Install Nginx package
  package { 'nginx':
    ensure => installed,
  }

  # Create necessary directories
  file { '/data':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0755',
  }

  file { '/data/web_static':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0755',
  }

  file { '/data/web_static/releases':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0755',
  }

  file { '/data/web_static/shared':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0755',
  }

  file { '/data/web_static/releases/test':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0755',
  }

  # Create a fake HTML file for testing
  file { '/data/web_static/releases/test/index.html':
    ensure  => file,
    content => '<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>',
    owner   => 'ubuntu',
    group   => 'ubuntu',
    mode    => '0644',
  }

  # Create symbolic link
  file { '/data/web_static/current':
    ensure => link,
    target => '/data/web_static/releases/test',
    owner  => 'root',
    group  => 'root',
    require => File['/data/web_static/releases/test/index.html'],
  }

  # Configure Nginx to serve content
  file { '/etc/nginx/sites-available/default':
    ensure  => file,
    content => template('nginx/default.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  # Ensure Nginx service is running
  service { 'nginx':
    ensure => running,
    enable => true,
  }
}

# Apply the setup_web_static class
include setup_web_static

