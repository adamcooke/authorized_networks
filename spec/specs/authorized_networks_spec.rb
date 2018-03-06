require 'spec_helper'

describe AuthorizedNetworks do

  context "#instance" do
    it "should return a global instance object" do
      expect(AuthorizedNetworks.instance).to be_a(AuthorizedNetworks::Instance)
    end
  end

  context "#valid_ip?" do
    it "should work with the global instance" do
      expect(AuthorizedNetworks.valid_ip?('127.0.0.1')).to be true
      expect(AuthorizedNetworks.valid_ip?('8.8.8.8')).to be false
    end
  end

  context "#valid_ip!" do
    it "should work with the global instance" do
      expect(AuthorizedNetworks.valid_ip!('127.0.0.1')).to be true
      expect { AuthorizedNetworks.valid_ip!('8.8.8.8') } .to raise_error(AuthorizedNetworks::UnauthorizedNetworkError)
    end
  end

end
