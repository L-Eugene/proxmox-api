# frozen_string_literal: true

require 'rspec'

describe 'ApiPath' do
  before(:each) do
    @api_object = double('ProxmoxAPI')
    allow(@api_object).to receive(:is_a?).with(ProxmoxAPI) { true }
  end

  it 'raises exception when object is not ProxmoxAPI' do
    [1, 'String', Class].each do |item|
      expect { ProxmoxAPI::ApiPath.new(item) }.to raise_error(ArgumentError)
    end
  end

  it 'collects api path using methods' do
    expect(ProxmoxAPI::ApiPath.new(@api_object).ticket.to_s).to eq 'ticket'
    expect(ProxmoxAPI::ApiPath.new(@api_object).nodes.pve1.to_s).to eq 'nodes/pve1'
  end

  it 'collects api path using []' do
    expect(ProxmoxAPI::ApiPath.new(@api_object)[:ticket].to_s).to eq 'ticket'
    expect(ProxmoxAPI::ApiPath.new(@api_object)[:nodes]['pve1'][15].to_s).to eq 'nodes/pve1/15'
  end

  it 'collects api path combining [] and methods' do
    expect(ProxmoxAPI::ApiPath.new(@api_object).nodes['pve1'].lxc.to_s).to eq 'nodes/pve1/lxc'
  end

  %i[get post delete put].each do |method|
    it "should send #{method} to ProxmoxAPI" do
      expect(@api_object).to receive(:submit).with(method, 'nodes/pve')
      ProxmoxAPI::ApiPath.new(@api_object).nodes.pve.__send__(method)
    end

    it "should send #{method}! to ProxmoxAPI" do
      expect(@api_object).to receive(:submit).with("#{method}!".to_sym, 'nodes/pve')
      ProxmoxAPI::ApiPath.new(@api_object).nodes.pve.__send__("#{method}!")
    end
  end
end
