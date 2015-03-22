require 'serverspec'

set :backend, :exec

%w{ zip unzip wget git openssl }.each do | pkg |
  describe package(pkg) do
    it { should be_installed }
  end
end
