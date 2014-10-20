#
# Cookbook Name:: octave
# Recipe:: default
#

if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  
  pkgs = %w{ sci-libs/cxsparse sci-libs/qrupdate sci-libs/hdf5 sci-libs/arpack sci-mathematics/glpk sci-libs/fftw media-libs/qhull dev-libs/libpcre  }

  Chef::Log.info "Installing octave dependencies"

  pkgs.each do |pkg|
    package pkg do
      action :install
    end
  end

  Chef::Log.info "Downloading octave source code"

  remote_file "#{Chef::Config[:file_cache_path]}/octave-3.8.1.tar.gz" do
    source "http://ftp.gnu.org/gnu/octave/octave-3.8.1.tar.gz"
    mode '0644'
    notifies :run, "bash[install_octave]", :immediately
  end

  Chef::Log.info "Compiling and installing ocatve"

  bash 'install_octave' do
    user "root"
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf octave-3.8.1.tar.gz
      (cd octave-3.8.1/ && ./configure && make && make install)
    EOH
    not_if { ::File.exists?("/usr/local/bin/octave") }
  end

end