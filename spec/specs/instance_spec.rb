require 'spec_helper'

describe AuthorizedNetworks::Instance do

  subject(:instance) do
    AuthorizedNetworks::Instance.new do |config|
      config.networks_file_path = File.expand_path('../../networks.yml', __FILE__)
    end
  end

  context "#networks" do

    it "should raise an error if the file doesn't exist" do
      instance = AuthorizedNetworks::Instance.new { |config| config.networks_file_path = "some/missing/path"}
      expect { instance.networks }.to raise_error(AuthorizedNetworks::NetworksConfigFileNotFoundError)
    end

    it "should return a hash of networks" do
      expect(instance.networks).to be_a(Hash)
    end

    it "should have symbols for keys" do
      expect(instance.networks[:default]).to be_a(Array)
    end

    it "should have IP Addrs" do
      expect(instance.networks[:default]).to all(be_a(IPAddr))
    end

    it "should not include invalid addresses" do
      expect(instance.networks[:default]).to_not include(nil)
    end

    it "should return the networks from the config if one is provided" do
      instance = AuthorizedNetworks::Instance.new { |config| config.networks = {'default' => ['8.8.8.8']}}
      expect(instance.networks[:default].first).to include('8.8.8.8')
      expect(instance.networks[:default]).to all(be_a(IPAddr))
    end
  end

  context ".valid_ip?" do
    it "should return false with an invalid address" do
      expect(instance.valid_ip?('blah')).to be false
    end

    it "should return true if in the default groups" do
      expect(instance.valid_ip?('127.0.0.1')).to be true
    end

    it "should return false if it's in another group" do
      expect(instance.valid_ip?('172.16.0.2')).to be false
    end

    it "should return true if it's in another group that's been added to the list" do
      instance = AuthorizedNetworks::Instance.new do |config|
        config.networks_file_path = File.expand_path('../../networks.yml', __FILE__)
        config.default_groups << :secondary_group
      end
      expect(instance.valid_ip?('172.16.0.2')).to be true
    end

    it "should allow a list of networks to be provided" do
      expect(instance.valid_ip?('172.16.0.2', :groups => [:secondary_group])).to be true
      expect(instance.valid_ip?('127.0.0.1', :groups => [:secondary_group])).to be false
    end

  end

  context "valid_ip!" do
    it "should raise an error on invalid IPs" do
      expect { instance.valid_ip!('172.16.0.2') }.to raise_error(AuthorizedNetworks::UnauthorizedNetworkError)
    end

    it "should return true on valid ips" do
      expect(instance.valid_ip!('127.0.0.1')).to be true
    end
  end

end
