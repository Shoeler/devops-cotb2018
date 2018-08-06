# encoding: utf-8
# copyright: 2018, Jonathan Leech-Pepin

resource_group = 'dummy-resourcegroup'
blob = 'cotbsamplestorage'

# Fix a possible bug where it states undefined method `Microsoft`
class Inspec::Resources::AzureResourceGroup
  def Microsoft
    nil
  end
end

control "Resource Group" do
  impact 1.0
  title resource_group
  describe azure_resource_group(name: resource_group) do
    its('vm_count') { should eq 0 }
    its('provisioning_state') { should eq 'Succeeded' }
    its('location') { should eq 'eastus' }
    its('total') { should eq 1 }
  end
end

control "Azure Storage" do
  impact 1.0
  title blob
  object = azure_generic_resource(name: blob, group_name: resource_group)
  describe 'Azure Blob Storage' do
    it 'should be provisioned' do
      expect(object.provisioning_state).to eq('Succeeded')
    end
    it 'has a file endpoint' do
      expect(object.properties.item['primaryEndpoints']['file']).to match(/#{blob}\.file.*/)
    end
  end
end
