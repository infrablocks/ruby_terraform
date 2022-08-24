# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::ResourceChange do
  describe '#address' do
    it 'returns the resource address as a string when content ' \
       'has symbol keys' do
      resource_address = 'module.some_module.some_resource.name'
      content =
        Support::Build.resource_change_content(address: resource_address)
      content = Support::Transform.symbolise_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.address).to(eq(resource_address))
    end

    it 'returns the resource address as a string when content ' \
       'has string keys' do
      resource_address = 'module.some_module.some_resource.name'
      content =
        Support::Build.resource_change_content(address: resource_address)
      content = Support::Transform.stringify_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.address).to(eq(resource_address))
    end
  end

  describe '#module_address' do
    context 'when content has symbol keys' do
      it 'returns nil when not a module resource change' do
        content = Support::Build.resource_change_content(
          {}, { module_resource: false }
        )
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.module_address).to(be_nil)
      end

      it 'returns the module address when a module resource change' do
        module_address = 'module.some_module'
        content = Support::Build.resource_change_content(
          { module_address: module_address },
          { module_resource: true }
        )
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.module_address).to(eq(module_address))
      end
    end

    context 'when content has string keys' do
      it 'returns nil when not a module resource change' do
        content = Support::Build.resource_change_content(
          {}, { module_resource: false }
        )
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.module_address).to(be_nil)
      end

      it 'returns the module address when a module resource change' do
        module_address = 'module.some_module'
        content = Support::Build.resource_change_content(
          { module_address: module_address },
          { module_resource: true }
        )
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.module_address).to(eq(module_address))
      end
    end
  end

  describe '#mode' do
    it 'returns the mode of the resource when content has symbol keys' do
      mode = 'managed'
      content = Support::Build.resource_change_content({ mode: mode })
      content = Support::Transform.symbolise_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.mode).to(eq(mode))
    end

    it 'returns the mode of the resource when content has string keys' do
      mode = 'managed'
      content = Support::Build.resource_change_content({ mode: mode })
      content = Support::Transform.stringify_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.mode).to(eq(mode))
    end
  end

  describe '#type' do
    it 'returns the type of the resource when content has symbol keys' do
      type = 'some_resource'
      content = Support::Build.resource_change_content({ type: type })
      content = Support::Transform.symbolise_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.type).to(eq(type))
    end

    it 'returns the type of the resource when content has string keys' do
      type = 'some_resource'
      content = Support::Build.resource_change_content({ type: type })
      content = Support::Transform.stringify_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.type).to(eq(type))
    end
  end

  describe '#name' do
    it 'returns the name of the resource when content has symbol keys' do
      name = 'name'
      content = Support::Build.resource_change_content({ name: name })
      content = Support::Transform.symbolise_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.name).to(eq(name))
    end

    it 'returns the name of the resource when content has string keys' do
      name = 'name'
      content = Support::Build.resource_change_content({ name: name })
      content = Support::Transform.stringify_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.name).to(eq(name))
    end
  end

  describe '#index' do
    context 'when content has symbol keys' do
      it 'returns nil when resource change is not for a multi-instance ' \
         'resource' do
        content = Support::Build.resource_change_content(
          {},
          { multi_instance_resource: false }
        )
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.index).to(be_nil)
      end

      it 'returns the index when resource change is for a multi-instance ' \
         'resource' do
        index = 2
        content = Support::Build.resource_change_content(
          { index: index },
          { multi_instance_resource: true }
        )
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.index).to(eq(index))
      end
    end

    context 'when content has string keys' do
      it 'returns nil when resource change is not for a multi-instance ' \
         'resource' do
        content = Support::Build.resource_change_content(
          {},
          { multi_instance_resource: false }
        )
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.index).to(be_nil)
      end

      it 'returns the index when resource change is for a multi-instance ' \
         'resource' do
        index = 2
        content = Support::Build.resource_change_content(
          { index: index },
          { multi_instance_resource: true }
        )
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.index).to(eq(index))
      end
    end
  end

  describe '#provider_name' do
    it 'returns the provider name of the resource when content ' \
       'has symbol keys' do
      provider_name = 'some_provider'
      content = Support::Build.resource_change_content(
        { provider_name: provider_name }
      )
      content = Support::Transform.symbolise_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.provider_name).to(eq(provider_name))
    end

    it 'returns the provider name of the resource when content ' \
       'has string keys' do
      provider_name = 'some_provider'
      content = Support::Build.resource_change_content(
        { provider_name: provider_name }
      )
      content = Support::Transform.stringify_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.provider_name).to(eq(provider_name))
    end
  end

  describe '#change' do
    it 'returns a RubyTerraform::Models::Change for the resource change ' \
       'when content has symbol keys' do
      change = Support::Build.change_content
      content = Support::Build.resource_change_content(
        { change: change }
      )
      content = Support::Transform.symbolise_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.change)
        .to(eq(RubyTerraform::Models::Change.new(change)))
    end

    it 'returns a RubyTerraform::Models::Change for the resource change ' \
       'when content has string keys' do
      change = Support::Build.change_content
      content = Support::Build.resource_change_content(
        { change: change }
      )
      content = Support::Transform.stringify_keys(content)
      resource_change = described_class.new(content)

      expect(resource_change.change)
        .to(eq(RubyTerraform::Models::Change.new(change)))
    end
  end

  describe '#no_op?' do
    context 'when content has symbol keys' do
      it 'returns true if the change represents a no-op' do
        change = Support::Build.no_op_change_content
        content = Support::Build.resource_change_content({ change: change })
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content({ change: change })
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.no_op?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      it 'returns true if the change represents a no-op' do
        change = Support::Build.no_op_change_content
        content = Support::Build.resource_change_content({ change: change })
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content({ change: change })
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.no_op?)
            .to(be(false))
        end
      end
    end
  end

  describe '#create?' do
    context 'when content has symbol keys' do
      it 'returns true if the change represents a create' do
        change = Support::Build.create_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(
            content
          )

          expect(resource_change.create?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      it 'returns true if the change represents a create' do
        change = Support::Build.create_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(
            content
          )

          expect(resource_change.create?)
            .to(be(false))
        end
      end
    end
  end

  describe '#read?' do
    context 'when content has symbol keys' do
      it 'returns true if the change represents a read' do
        change = Support::Build.read_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(
            content
          )

          expect(resource_change.read?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      it 'returns true if the change represents a read' do
        change = Support::Build.read_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(
            content
          )

          expect(resource_change.read?)
            .to(be(false))
        end
      end
    end
  end

  describe '#update?' do
    context 'when content has symbol keys' do
      it 'returns true if the change represents an update' do
        change = Support::Build.update_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.update?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      it 'returns true if the change represents an update' do
        change = Support::Build.update_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.update?)
            .to(be(false))
        end
      end
    end
  end

  describe '#replace_delete_before_create?' do
    context 'when content has symbol keys' do
      it 'returns true if the change represents a replace ' \
         '(delete before create)' do
        change = Support::Build.replace_delete_before_create_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.replace_delete_before_create?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      it 'returns true if the change represents a replace ' \
         '(delete before create)' do
        change = Support::Build.replace_delete_before_create_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.replace_delete_before_create?)
            .to(be(false))
        end
      end
    end
  end

  describe '#replace_create_before_delete?' do
    context 'when content has symbol keys' do
      it 'returns true if the change represents a replace ' \
         '(create before delete)' do
        change = Support::Build.replace_create_before_delete_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.replace_create_before_delete?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      it 'returns true if the change represents a replace ' \
         '(create before delete)' do
        change = Support::Build.replace_create_before_delete_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.replace_create_before_delete?)
            .to(be(false))
        end
      end
    end
  end

  describe '#replace?' do
    context 'when content has symbol keys' do
      {
        'replace (delete before create)' =>
          Support::Build.replace_delete_before_create_change_content,
        'replace (create before delete)' =>
          Support::Build.replace_create_before_delete_change_content
      }.each do |entry|
        it "returns true if the change represents a #{entry[0]}" do
          change = entry[1]
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(
            content
          )

          expect(resource_change.replace?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      {
        'replace (delete before create)' =>
          Support::Build.replace_delete_before_create_change_content,
        'replace (create before delete)' =>
          Support::Build.replace_create_before_delete_change_content
      }.each do |entry|
        it "returns true if the change represents a #{entry[0]}" do
          change = entry[1]
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(
            content
          )

          expect(resource_change.replace?)
            .to(be(false))
        end
      end
    end
  end

  describe '#delete?' do
    context 'when content has symbol keys' do
      it 'returns true if the change represents a delete' do
        change = Support::Build.delete_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(
          content
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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.delete?)
            .to(be(false))
        end
      end
    end

    context 'when content has string keys' do
      it 'returns true if the change represents a delete' do
        change = Support::Build.delete_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(
          content
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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.delete?)
            .to(be(false))
        end
      end
    end
  end

  describe '#present_before?' do
    context 'when content has symbol keys' do
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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.present_before?)
            .to(be(true))
        end
      end

      it 'returns false if the change represents a create' do
        change = Support::Build.create_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.present_before?)
          .to(be(false))
      end
    end

    context 'when content has string keys' do
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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.present_before?)
            .to(be(true))
        end
      end

      it 'returns false if the change represents a create' do
        change = Support::Build.create_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.present_before?)
          .to(be(false))
      end
    end
  end

  describe '#present_after?' do
    context 'when content has symbol keys' do
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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.symbolise_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.present_after?)
            .to(be(true))
        end
      end

      it 'returns false if the change represents a delete' do
        change = Support::Build.delete_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.symbolise_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.present_after?)
          .to(be(false))
      end
    end

    context 'when content has string keys' do
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
          content = Support::Build.resource_change_content(change: change)
          content = Support::Transform.stringify_keys(content)
          resource_change = described_class.new(content)

          expect(resource_change.present_after?)
            .to(be(true))
        end
      end

      it 'returns false if the change represents a delete' do
        change = Support::Build.delete_change_content
        content = Support::Build.resource_change_content(change: change)
        content = Support::Transform.stringify_keys(content)
        resource_change = described_class.new(content)

        expect(resource_change.present_after?)
          .to(be(false))
      end
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same and state ' \
       'uses symbol keys' do
      content = Support::Build.resource_change_content
      content = Support::Transform.symbolise_keys(content)

      value1 = described_class.new(content)
      value2 = described_class.new(content)

      expect(value1).to(eq(value2))
    end

    it 'returns true when the state and class are the same and state ' \
       'uses string keys' do
      content = Support::Build.resource_change_content
      content = Support::Transform.stringify_keys(content)

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

    it 'returns true when the state is the same but one uses symbol keys ' \
       'and the other uses string keys' do
      content = Support::Build.resource_change_content
      stringified_content = Support::Transform.stringify_keys(content)
      symbolised_content = Support::Transform.symbolise_keys(content)

      value1 = described_class.new(stringified_content)
      value2 = described_class.new(symbolised_content)

      expect(value1).to(eq(value2))
    end

    it 'returns false when the classes are different' do
      content = Support::Build.resource_change_content

      value1 = described_class.new(content)
      value2 = Class.new(described_class).new(content)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same and ' \
       'state uses symbols for keys' do
      content = Support::Build.resource_change_content
      content = Support::Transform.symbolise_keys(content)

      value1 = described_class.new(content)
      value2 = described_class.new(content)

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has the same result when the state and class are the same and ' \
       'state uses strings for keys' do
      content = Support::Build.resource_change_content
      content = Support::Transform.stringify_keys(content)

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

    it 'has the same result when the state and class are the same and ' \
       'one uses strings for keys and the other uses symbols for keys' do
      content = Support::Build.resource_change_content
      stringified_content = Support::Transform.stringify_keys(content)
      symbolised_content = Support::Transform.symbolise_keys(content)

      value1 = described_class.new(stringified_content)
      value2 = described_class.new(symbolised_content)

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      content = Support::Build.resource_change_content

      value1 = described_class.new(content)
      value2 = Class.new(described_class).new(content)

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'inspects the underlying content with symbol keys ' \
       'when state has symbol keys' do
      resource_change_content = Support::Build.resource_change_content
      resource_change_content =
        Support::Transform.symbolise_keys(resource_change_content)
      change = described_class.new(resource_change_content)

      expect(change.inspect).to(eq(resource_change_content.inspect))
    end

    it 'inspects the underlying content with symbol keys ' \
       'when state has string keys' do
      resource_change_content = Support::Build.resource_change_content
      stringified_resource_change_content =
        Support::Transform.stringify_keys(resource_change_content)
      symbolised_change_resource_content =
        Support::Transform.symbolise_keys(resource_change_content)
      change = described_class.new(stringified_resource_change_content)

      expect(change.inspect).to(eq(symbolised_change_resource_content.inspect))
    end
  end

  describe '#to_h' do
    it 'returns the underlying content with symbol keys ' \
       'when state has symbol keys' do
      resource_change_content = Support::Build.resource_change_content
      resource_change_content =
        Support::Transform.symbolise_keys(resource_change_content)
      change = described_class.new(resource_change_content)

      expect(change.to_h).to(eq(resource_change_content))
    end

    it 'returns the underlying content with symbol keys ' \
       'when state has string keys' do
      resource_change_content = Support::Build.change_content
      stringified_change_content =
        Support::Transform.stringify_keys(resource_change_content)
      symbolised_change_content =
        Support::Transform.symbolise_keys(resource_change_content)
      change = described_class.new(stringified_change_content)

      expect(change.to_h).to(eq(symbolised_change_content))
    end
  end
end
