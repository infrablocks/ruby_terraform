# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/NestedGroups
describe RubyTerraform::Models::Plan do
  describe '#format_version' do
    it 'returns the format version when content uses symbol keys' do
      format_version = '1.0'
      content = Support::Build.plan_content(format_version:)
      content = Support::Transform.symbolise_keys(content)
      plan = described_class.new(content)

      expect(plan.format_version).to(eq(format_version))
    end

    it 'returns the format version when content uses string keys' do
      format_version = '1.0'
      content = Support::Build.plan_content(format_version:)
      content = Support::Transform.stringify_keys(content)
      plan = described_class.new(content)

      expect(plan.format_version).to(eq(format_version))
    end
  end

  describe '#terraform_version' do
    it 'returns the Terraform version when content uses symbol keys' do
      terraform_version = '1.1.9'
      content =
        Support::Build.plan_content(terraform_version:)
      content = Support::Transform.symbolise_keys(content)
      plan = described_class.new(content)

      expect(plan.terraform_version).to(eq(terraform_version))
    end

    it 'returns the Terraform version when content uses string keys' do
      terraform_version = '1.1.9'
      content =
        Support::Build.plan_content(terraform_version:)
      content = Support::Transform.stringify_keys(content)
      plan = described_class.new(content)

      expect(plan.terraform_version).to(eq(terraform_version))
    end
  end

  describe '#variables' do
    it 'returns the variables when content uses symbol keys' do
      variables = {
        var1: Support::Build.variable_content(value: 'val1'),
        var2: Support::Build.variable_content(value: 'val1')
      }
      content = Support::Build.plan_content(variables:)
      content = Support::Transform.symbolise_keys(content)
      plan = described_class.new(content)

      expect(plan.variables).to(eq(variables))
    end

    it 'returns the variables when content uses string keys' do
      variables = {
        var1: Support::Build.variable_content(value: 'val1'),
        var2: Support::Build.variable_content(value: 'val1')
      }
      content = Support::Build.plan_content(variables:)
      content = Support::Transform.stringify_keys(content)
      plan = described_class.new(content)

      expect(plan.variables).to(eq(variables))
    end

    it 'returns an empty map when no variables' do
      content = Support::Build.plan_content
      content = Support::Transform.symbolise_keys(content)
      content = content.tap { |c| c.delete(:variables) }
      plan = described_class.new(content)

      expect(plan.variables).to(eq({}))
    end
  end

  describe '#variable_values' do
    it 'return a map of variable values when content uses symbol keys' do
      variables = {
        var1: Support::Build.variable_content(value: 'val1'),
        var2: Support::Build.variable_content(value: 'val2')
      }
      content = Support::Build.plan_content(variables:)
      content = Support::Transform.symbolise_keys(content)
      plan = described_class.new(content)

      expect(plan.variable_values)
        .to(eq({
                 var1: 'val1',
                 var2: 'val2'
               }))
    end

    it 'return a map of variable values when content uses string keys' do
      variables = {
        var1: Support::Build.variable_content(value: 'val1'),
        var2: Support::Build.variable_content(value: 'val2')
      }
      content = Support::Build.plan_content(variables:)
      content = Support::Transform.stringify_keys(content)
      plan = described_class.new(content)

      expect(plan.variable_values)
        .to(eq({
                 var1: 'val1',
                 var2: 'val2'
               }))
    end
  end

  describe '#resource_changes' do
    it 'returns a resource change model for each of the resource changes ' \
       'when content uses symbols as keys' do
      resource_change_content1 = Support::Build.resource_change_content
      resource_change_content2 = Support::Build.resource_change_content

      content = Support::Build.plan_content(
        {
          resource_changes: [
            resource_change_content1,
            resource_change_content2
          ]
        }
      )
      content = Support::Transform.symbolise_keys(content)
      plan = described_class.new(content)

      expect(plan.resource_changes)
        .to(contain_exactly(
              RubyTerraform::Models::ResourceChange
                .new(resource_change_content1),
              RubyTerraform::Models::ResourceChange
                .new(resource_change_content2)
            ))
    end

    it 'returns a resource change model for each of the resource changes ' \
       'when content uses strings as keys' do
      resource_change_content1 = Support::Build.resource_change_content
      resource_change_content2 = Support::Build.resource_change_content

      content = Support::Build.plan_content(
        {
          resource_changes: [
            resource_change_content1,
            resource_change_content2
          ]
        }
      )
      content = Support::Transform.stringify_keys(content)
      plan = described_class.new(content)

      expect(plan.resource_changes)
        .to(contain_exactly(
              RubyTerraform::Models::ResourceChange
                .new(resource_change_content1),
              RubyTerraform::Models::ResourceChange
                .new(resource_change_content2)
            ))
    end

    it 'returns an empty array when no resource changes' do
      content = Support::Build.plan_content
      content = Support::Transform.symbolise_keys(content)
      content = content.tap { |c| c.delete(:resource_changes) }
      plan = described_class.new(content)

      expect(plan.resource_changes).to(eq([]))
    end
  end

  describe '#output_changes' do
    it 'returns an output change model for each of the output changes ' \
       'when content uses symbols for keys' do
      output_name1 = Support::Random.output_name.to_sym
      output_name2 = Support::Random.output_name.to_sym
      output_change_content1 = Support::Build.output_change_content
      output_change_content2 = Support::Build.output_change_content

      content = Support::Build.plan_content(
        output_changes: {
          output_name1 => output_change_content1,
          output_name2 => output_change_content2
        }
      )
      content = Support::Transform.symbolise_keys(content)
      plan = described_class.new(content)

      expect(plan.output_changes)
        .to(contain_exactly(
              RubyTerraform::Models::OutputChange
                .new(output_name1, output_change_content1),
              RubyTerraform::Models::OutputChange
                .new(output_name2, output_change_content2)
            ))
    end

    it 'returns an output change model for each of the output changes ' \
       'when content uses strings for keys' do
      output_name1 = Support::Random.output_name
      output_name2 = Support::Random.output_name
      output_change_content1 = Support::Build.output_change_content
      output_change_content2 = Support::Build.output_change_content

      content = Support::Build.plan_content(
        output_changes: {
          output_name1 => output_change_content1,
          output_name2 => output_change_content2
        }
      )
      content = Support::Transform.stringify_keys(content)
      plan = described_class.new(content)

      expect(plan.output_changes)
        .to(contain_exactly(
              RubyTerraform::Models::OutputChange
                .new(output_name1, output_change_content1),
              RubyTerraform::Models::OutputChange
                .new(output_name2, output_change_content2)
            ))
    end

    it 'returns an empty array when no output changes' do
      content = Support::Build.plan_content
      content = Support::Transform.symbolise_keys(content)
      content = content.tap { |c| c.delete(:output_changes) }
      plan = described_class.new(content)

      expect(plan.output_changes).to(eq([]))
    end
  end

  describe '#resource_changes_matching' do
    context 'when content uses symbols for keys' do
      describe 'for type' do
        it 'returns resource changes with matching type' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              change: Support::Build.create_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'other_resource_type',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(type: 'some_resource_type')

          expect(resource_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::ResourceChange.new(
                      resource_change_content1
                    )
                  ]
                ))
        end

        it 'returns empty array if resource changes have wrong type' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'other_resource_type1',
              change: Support::Build.update_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'other_resource_type2',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(type: 'some_resource_type')

          expect(resource_changes).to(eq([]))
        end

        it 'returns an empty array when no resource changes' do
          content = Support::Build.plan_content(
            resource_changes: []
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(type: 'some_resource_type')

          expect(resource_changes).to(eq([]))
        end
      end

      describe 'for type and name' do
        it 'returns resource changes with matching type and name' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'some_instance',
              change: Support::Build.update_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'some_instance',
              change: Support::Build.create_change_content
            )
          resource_change_content3 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'other_instance',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2,
              resource_change_content3
            ]
          )
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(
              type: 'some_resource_type', name: 'some_instance'
            )

          expect(resource_changes)
            .to(eq([
                     RubyTerraform::Models::ResourceChange.new(
                       resource_change_content1
                     ),
                     RubyTerraform::Models::ResourceChange.new(
                       resource_change_content2
                     )
                   ]))
        end

        it 'returns empty array if resource changes have wrong ' \
           'type or name' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'other_resource_type',
              name: 'some_instance',
              change: Support::Build.update_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'other_instance',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(
              type: 'some_resource_type',
              name: 'some_resource_name'
            )

          expect(resource_changes).to(eq([]))
        end

        it 'returns an empty array when no create resource changes' do
          content = Support::Build.plan_content(
            resource_changes: []
          )
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(
              type: 'some_resource_type',
              name: 'some_instance'
            )

          expect(resource_changes).to(eq([]))
        end
      end
    end

    context 'when content uses strings for keys' do
      describe 'for type' do
        it 'returns resource changes with matching type' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              change: Support::Build.create_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'other_resource_type',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(type: 'some_resource_type')

          expect(resource_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::ResourceChange.new(
                      resource_change_content1
                    )
                  ]
                ))
        end

        it 'returns empty array if resource changes have wrong type' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'other_resource_type1',
              change: Support::Build.update_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'other_resource_type2',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(type: 'some_resource_type')

          expect(resource_changes).to(eq([]))
        end

        it 'returns an empty array when no resource changes' do
          content = Support::Build.plan_content(
            resource_changes: []
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(type: 'some_resource_type')

          expect(resource_changes).to(eq([]))
        end
      end

      describe 'for type and name' do
        it 'returns resource changes with matching type and name' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'some_instance',
              change: Support::Build.update_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'some_instance',
              change: Support::Build.create_change_content
            )
          resource_change_content3 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'other_instance',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2,
              resource_change_content3
            ]
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(
              type: 'some_resource_type', name: 'some_instance'
            )

          expect(resource_changes)
            .to(eq([
                     RubyTerraform::Models::ResourceChange.new(
                       resource_change_content1
                     ),
                     RubyTerraform::Models::ResourceChange.new(
                       resource_change_content2
                     )
                   ]))
        end

        it 'returns empty array if resource changes have wrong ' \
           'type or name' do
          resource_change_content1 =
            Support::Build.resource_change_content(
              type: 'other_resource_type',
              name: 'some_instance',
              change: Support::Build.update_change_content
            )
          resource_change_content2 =
            Support::Build.resource_change_content(
              type: 'some_resource_type',
              name: 'other_instance',
              change: Support::Build.create_change_content
            )

          content = Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(
              type: 'some_resource_type',
              name: 'some_resource_name'
            )

          expect(resource_changes).to(eq([]))
        end

        it 'returns an empty array when no create resource changes' do
          content = Support::Build.plan_content(
            resource_changes: []
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          resource_changes =
            plan.resource_changes_matching(
              type: 'some_resource_type',
              name: 'some_instance'
            )

          expect(resource_changes).to(eq([]))
        end
      end
    end
  end

  describe '#output_changes_matching' do
    context 'when content uses symbols for keys' do
      describe 'for name' do
        it 'returns output change with matching name in array' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_change_content1 = Support::Build.output_change_content
          output_change_content2 = Support::Build.output_change_content

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name2)

          expect(output_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::OutputChange.new(
                      output_name2, output_change_content2
                    )
                  ]
                ))
        end

        it 'returns empty array if no output change with provided name' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.output_change_content
          output_change_content2 = Support::Build.output_change_content

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name3)

          expect(output_changes).to(eq([]))
        end

        it 'returns an empty array when there are no output changes' do
          content = Support::Build.plan_content(
            output_changes: {}
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: Support::Random.output_name)

          expect(output_changes).to(eq([]))
        end
      end

      describe 'for query method' do
        it 'returns output changes satisfying the specified query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.delete_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(create?: true)

          expect(output_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::OutputChange.new(
                      output_name1, output_change_content1
                    ),
                    RubyTerraform::Models::OutputChange.new(
                      output_name3, output_change_content3
                    )
                  ]
                ))
        end

        it 'returns empty array if no output change satisfy query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(delete?: true)

          expect(output_changes).to(eq([]))
        end

        it 'returns an empty array when there are no output changes' do
          content = Support::Build.plan_content(
            output_changes: {}
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(update?: true)

          expect(output_changes).to(eq([]))
        end
      end

      describe 'for name and query method' do
        it 'returns output change with matching name if satisfying query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.delete_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name1, create?: true)

          expect(output_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::OutputChange.new(
                      output_name1, output_change_content1
                    )
                  ]
                ))
        end

        it 'returns empty array if no output change satisfies query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name1, delete?: true)

          expect(output_changes).to(eq([]))
        end

        it 'returns empty array if no output change has name' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name3, create?: true)

          expect(output_changes).to(eq([]))
        end

        it 'returns an empty array when there are no output changes' do
          content = Support::Build.plan_content(
            output_changes: {}
          )
          content = Support::Transform.symbolise_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(
              name: Support::Random.output_name, create?: true
            )

          expect(output_changes).to(eq([]))
        end
      end
    end

    context 'when content uses strings for keys' do
      describe 'for name' do
        it 'returns output change with matching name in array' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_change_content1 = Support::Build.output_change_content
          output_change_content2 = Support::Build.output_change_content

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name2)

          expect(output_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::OutputChange.new(
                      output_name2, output_change_content2
                    )
                  ]
                ))
        end

        it 'returns empty array if no output change with provided name' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.output_change_content
          output_change_content2 = Support::Build.output_change_content

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name3)

          expect(output_changes).to(eq([]))
        end

        it 'returns an empty array when there are no output changes' do
          content = Support::Build.plan_content(
            output_changes: {}
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: Support::Random.output_name)

          expect(output_changes).to(eq([]))
        end
      end

      describe 'for query method' do
        it 'returns output changes satisfying the specified query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.delete_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(create?: true)

          expect(output_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::OutputChange.new(
                      output_name1, output_change_content1
                    ),
                    RubyTerraform::Models::OutputChange.new(
                      output_name3, output_change_content3
                    )
                  ]
                ))
        end

        it 'returns empty array if no output change satisfy query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(delete?: true)

          expect(output_changes).to(eq([]))
        end

        it 'returns an empty array when there are no output changes' do
          content = Support::Build.plan_content(
            output_changes: {}
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(update?: true)

          expect(output_changes).to(eq([]))
        end
      end

      describe 'for name and query method' do
        it 'returns output change with matching name if satisfying query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.delete_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name1, create?: true)

          expect(output_changes)
            .to(eq(
                  [
                    RubyTerraform::Models::OutputChange.new(
                      output_name1, output_change_content1
                    )
                  ]
                ))
        end

        it 'returns empty array if no output change satisfies query' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content3 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name1, delete?: true)

          expect(output_changes).to(eq([]))
        end

        it 'returns empty array if no output change has name' do
          output_name1 = Support::Random.output_name
          output_name2 = Support::Random.output_name
          output_name3 = Support::Random.output_name
          output_change_content1 = Support::Build.create_change_content(
            {}, { type: :output }
          )
          output_change_content2 = Support::Build.create_change_content(
            {}, { type: :output }
          )

          content = Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(name: output_name3, create?: true)

          expect(output_changes).to(eq([]))
        end

        it 'returns an empty array when there are no output changes' do
          content = Support::Build.plan_content(
            output_changes: {}
          )
          content = Support::Transform.stringify_keys(content)
          plan = described_class.new(content)

          output_changes =
            plan.output_changes_matching(
              name: Support::Random.output_name, create?: true
            )

          expect(output_changes).to(eq([]))
        end
      end
    end
  end

  describe '#==' do
    it 'returns true when the content and class are the same' do
      content = Support::Build.plan_content

      value1 = described_class.new(content)
      value2 = described_class.new(content)

      expect(value1).to(eq(value2))
    end

    it 'returns false when the content is different' do
      content1 = Support::Build.plan_content
      content2 = Support::Build.plan_content

      value1 = described_class.new(content1)
      value2 = described_class.new(content2)

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      content = Support::Build.plan_content

      value1 = described_class.new(content)
      value2 = Class.new(described_class).new(content)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the content and class are the same' do
      content = Support::Build.plan_content

      value1 = described_class.new(content)
      value2 = described_class.new(content)

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the content is different' do
      content1 = Support::Build.plan_content
      content2 = Support::Build.plan_content

      value1 = described_class.new(content1)
      value2 = described_class.new(content2)

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      content = Support::Build.plan_content

      value1 = described_class.new(content)
      value2 = Class.new(described_class).new(content)

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'inspects the underlying content as a hash with symbol keys when ' \
       'content has symbol keys' do
      plan_content = Support::Build.plan_content
      plan_content = Support::Transform.symbolise_keys(plan_content)
      plan = described_class.new(plan_content)

      expect(plan.inspect).to(eq(plan_content.inspect))
    end

    it 'inspects the underlying content as a hash with symbol keys when ' \
       'content has string keys' do
      plan_content = Support::Build.plan_content
      stringified_plan_content = Support::Transform.stringify_keys(plan_content)
      symbolised_plan_content = Support::Transform.symbolise_keys(plan_content)
      plan = described_class.new(stringified_plan_content)

      expect(plan.inspect).to(eq(symbolised_plan_content.inspect))
    end
  end

  describe '#to_h' do
    it 'returns the underlying content with symbol keys when ' \
       'content has symbol keys' do
      plan_content = Support::Build.plan_content
      plan_content = Support::Transform.symbolise_keys(plan_content)
      plan = described_class.new(plan_content)

      expect(plan.to_h).to(eq(plan_content))
    end

    it 'returns the underlying content with symbol keys when ' \
       'content has string keys' do
      plan_content = Support::Build.plan_content
      stringified_plan_content = Support::Transform.stringify_keys(plan_content)
      symbolised_plan_content = Support::Transform.symbolise_keys(plan_content)
      plan = described_class.new(stringified_plan_content)

      expect(plan.to_h).to(eq(symbolised_plan_content))
    end
  end
end
# rubocop:enable RSpec/NestedGroups
