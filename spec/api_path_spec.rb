# frozen_string_literal: true

require 'rspec'

describe 'ApiPath' do
  before(:each) do
    @api_object = instance_double('ProxmoxAPI')
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
end
