# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::ResourceChange do
  describe '#address' do
    it 'returns the resource address' do
      resource_address = 'module.some_module.some_resource.name'
      resource_change = described_class.new(
        Support::Build.resource_change_content({ address: resource_address })
      )

      expect(resource_change.address).to(eq(resource_address))
    end
  end

  describe '#module_address' do
    it 'returns nil when not a module resource change' do
      resource_change = described_class.new(
        Support::Build.resource_change_content(
          {},
          { module_resource: false }
        )
      )

      expect(resource_change.module_address).to(be_nil)
    end

    it 'returns the module address when a module resource change' do
      module_address = 'module.some_module'
      resource_change = described_class.new(
        Support::Build.resource_change_content(
          { module_address: module_address },
          { module_resource: true }
        )
      )

      expect(resource_change.module_address).to(eq(module_address))
    end
  end

  describe '#mode' do
    it 'returns the mode of the resource' do
      mode = 'managed'
      resource_change = described_class.new(
        Support::Build.resource_change_content({ mode: mode })
      )

      expect(resource_change.mode).to(eq(mode))
    end
  end

  describe '#type' do
    it 'returns the type of the resource' do
      type = 'some_resource'
      resource_change = described_class.new(
        Support::Build.resource_change_content({ type: type })
      )

      expect(resource_change.type).to(eq(type))
    end
  end

  describe '#name' do
    it 'returns the name of the resource' do
      name = 'name'
      resource_change = described_class.new(
        Support::Build.resource_change_content({ name: name })
      )

      expect(resource_change.name).to(eq(name))
    end
  end

  describe '#index' do
    it 'returns nil when resource change is not for a multi-instance ' \
       'resource' do
      resource_change = described_class.new(
        Support::Build.resource_change_content(
          {},
          { multi_instance_resource: false }
        )
      )

      expect(resource_change.index).to(be_nil)
    end

    it 'returns the index when resource change is for a multi-instance ' \
       'resource' do
      index = 2
      resource_change = described_class.new(
        Support::Build.resource_change_content(
          { index: index },
          { multi_instance_resource: true }
        )
      )

      expect(resource_change.index).to(eq(index))
    end
  end

  describe '#provider_name' do
    it 'returns the provider name of the resource' do
      provider_name = 'some_provider'
      resource_change = described_class.new(
        Support::Build.resource_change_content(
          { provider_name: provider_name }
        )
      )

      expect(resource_change.provider_name).to(eq(provider_name))
    end
  end

  describe '#change' do
    it 'returns a RubyTerraform::Models::Change for the resource change' do
      change = Support::Build.change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content(
          { change: change }
        )
      )

      expect(resource_change.change)
        .to(eq(RubyTerraform::Models::Change.new(change)))
    end
  end

  describe '#no_op?' do
    it 'returns true if the change represents a no-op' do
      change = Support::Build.no_op_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.no_op?)
        .to(be(true))
    end

    {
      'create' => Support::Build.create_change_content,
      'read' => Support::Build.read_change_content,
      'update' => Support::Build.update_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.no_op?)
          .to(be(false))
      end
    end
  end

  describe '#create?' do
    it 'returns true if the change represents a create' do
      change = Support::Build.create_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.create?)
        .to(be(true))
    end

    {
      'no_op' => Support::Build.no_op_change_content,
      'read' => Support::Build.read_change_content,
      'update' => Support::Build.update_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.create?)
          .to(be(false))
      end
    end
  end

  describe '#read?' do
    it 'returns true if the change represents a read' do
      change = Support::Build.read_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.read?)
        .to(be(true))
    end

    {
      'no_op' => Support::Build.no_op_change_content,
      'create' => Support::Build.create_change_content,
      'update' => Support::Build.update_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.read?)
          .to(be(false))
      end
    end
  end

  describe '#update?' do
    it 'returns true if the change represents an update' do
      change = Support::Build.update_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.update?)
        .to(be(true))
    end

    {
      'no_op' => Support::Build.no_op_change_content,
      'create' => Support::Build.create_change_content,
      'read' => Support::Build.read_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.update?)
          .to(be(false))
      end
    end
  end

  describe '#replace_delete_before_create?' do
    it 'returns true if the change represents a replace ' \
       '(delete before create)' do
      change = Support::Build.replace_delete_before_create_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.replace_delete_before_create?)
        .to(be(true))
    end

    {
      'no_op' => Support::Build.no_op_change_content,
      'create' => Support::Build.create_change_content,
      'read' => Support::Build.read_change_content,
      'update' => Support::Build.update_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.replace_delete_before_create?)
          .to(be(false))
      end
    end
  end

  describe '#replace_create_before_delete?' do
    it 'returns true if the change represents a replace ' \
       '(create before delete)' do
      change = Support::Build.replace_create_before_delete_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.replace_create_before_delete?)
        .to(be(true))
    end

    {
      'no_op' => Support::Build.no_op_change_content,
      'create' => Support::Build.create_change_content,
      'read' => Support::Build.read_change_content,
      'update' => Support::Build.update_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.replace_create_before_delete?)
          .to(be(false))
      end
    end
  end

  describe '#replace?' do
    {
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content
    }.each do |entry|
      it "returns true if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.replace?)
          .to(be(true))
      end
    end

    {
      'no_op' => Support::Build.no_op_change_content,
      'create' => Support::Build.create_change_content,
      'read' => Support::Build.read_change_content,
      'update' => Support::Build.update_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.replace?)
          .to(be(false))
      end
    end
  end

  describe '#delete?' do
    it 'returns true if the change represents a delete' do
      change = Support::Build.delete_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.delete?)
        .to(be(true))
    end

    {
      'no_op' => Support::Build.no_op_change_content,
      'create' => Support::Build.create_change_content,
      'read' => Support::Build.read_change_content,
      'update' => Support::Build.update_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.delete?)
          .to(be(false))
      end
    end
  end

  describe '#present_before?' do
    {
      'no-op' => Support::Build.no_op_change_content,
      'read' => Support::Build.read_change_content,
      'update' => Support::Build.update_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content,
      'delete' => Support::Build.delete_change_content
    }.each do |entry|
      it "returns true if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.present_before?)
          .to(be(true))
      end
    end

    it 'returns false if the change represents a create' do
      change = Support::Build.create_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.present_before?)
        .to(be(false))
    end
  end

  describe '#present_after?' do
    {
      'no-op' => Support::Build.no_op_change_content,
      'read' => Support::Build.read_change_content,
      'create' => Support::Build.create_change_content,
      'update' => Support::Build.update_change_content,
      'replace (delete before create)' =>
        Support::Build.replace_delete_before_create_change_content,
      'replace (create before delete)' =>
        Support::Build.replace_create_before_delete_change_content
    }.each do |entry|
      it "returns true if the change represents a #{entry[0]}" do
        change = entry[1]
        resource_change = described_class.new(
          Support::Build.resource_change_content({ change: change })
        )

        expect(resource_change.present_after?)
          .to(be(true))
      end
    end

    it 'returns false if the change represents a delete' do
      change = Support::Build.delete_change_content
      resource_change = described_class.new(
        Support::Build.resource_change_content({ change: change })
      )

      expect(resource_change.present_after?)
        .to(be(false))
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same' do
      content = Support::Build.resource_change_content

      value1 = described_class.new(content)
      value2 = described_class.new(content)

      expect(value1).to(eq(value2))
    end

    it 'returns false when the state is different' do
      content1 = Support::Build.resource_change_content
      content2 = Support::Build.resource_change_content

      value1 = described_class.new(content1)
      value2 = described_class.new(content2)

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      content = Support::Build.resource_change_content

      value1 = described_class.new(content)
      value2 = Class.new(described_class).new(content)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same' do
      content = Support::Build.resource_change_content

      value1 = described_class.new(content)
      value2 = described_class.new(content)

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the state is different' do
      content1 = Support::Build.resource_change_content
      content2 = Support::Build.resource_change_content

      value1 = described_class.new(content1)
      value2 = described_class.new(content2)

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      content = Support::Build.resource_change_content

      value1 = described_class.new(content)
      value2 = Class.new(described_class).new(content)

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'inspects the underlying content' do
      resource_change_content = Support::Build.resource_change_content
      resource_change = described_class.new(resource_change_content)

      expect(resource_change.inspect).to(eq(resource_change_content.inspect))
    end
  end

  describe '#to_h' do
    it 'returns the underlying content' do
      resource_change_content = Support::Build.resource_change_content
      resource_change = described_class.new(resource_change_content)

      expect(resource_change.to_h).to(eq(resource_change_content))
    end
  end
end
