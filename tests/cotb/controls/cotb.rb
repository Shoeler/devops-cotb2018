params = yaml(content: inspec.profile.file('params.yaml')).params

location = params['location']
resource_group = params['resource_group']
registry = params['registry']
kubernetes = params['kubernetes']
kube_mc = "MC_#{resource_group}_#{kubernetes}_#{location}"

# Validate Resource Group
# 2 resources (aks and acr), no IPs, no vms
control 'Resource Group' do
  impact 1.0
  title resource_group
  describe azure_resource_group(name: resource_group) do
    its('vm_count') { should eq 0 }
    its('has_public_ips?') { should eq false }
    its('total') { should eq 2 }
    its('provisioning_state') { should eq 'Succeeded' }
    its('location') { should eq location }
  end
end

# Validate Container Registry
control 'Azure Container Registry' do
  impact 1.0
  title registry
  object = azure_generic_resource(name: registry, group_name: resource_group)
  describe 'Container registry' do
    it "should be provisioned" do
      expect(object.provisioning_state).to eq('Succeeded')
    end
    it "has a loginServer matching the resource name" do
      expect(object.properties.item['loginServer']).to match(/^#{registry}/)
    end
  end
end

# Validate Kubernetes Instance
control "Azure Kubernetes Service" do
  impact 1.0
  title kubernetes
  kube_res = azure_generic_resource(name: kubernetes, group_name: resource_group)
  describe "Kubernetes Instance" do
    it "should be provisioned" do
      expect(kube_res.provisioning_state).to eq('Succeeded')
    end
    it "should have a managed resource group" do
      expect(kube_res.properties.item['nodeResourceGroup']).to eq(kube_mc)
    end
  end
  describe azure_resource_group(name: kube_mc) do
    its('total') { should eq 12 }
    its('has_public_ips?') { should eq true }
    its('provisioning_state') { should eq 'Succeeded' }
    its('location') { should eq location }
  end
end
