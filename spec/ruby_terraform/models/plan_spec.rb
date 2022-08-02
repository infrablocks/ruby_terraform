# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::Plan do
  describe '#format_version' do
    it 'returns the format version' do
      format_version = '1.0'
      plan = described_class.new(
        Support::Build.plan_content({ format_version: format_version })
      )

      expect(plan.format_version).to(eq(format_version))
    end
  end

  describe '#terraform_version' do
    it 'returns the Terraform version' do
      terraform_version = '1.1.9'
      plan = described_class.new(
        Support::Build.plan_content(
          { terraform_version: terraform_version }
        )
      )

      expect(plan.terraform_version).to(eq(terraform_version))
    end
  end

  describe '#variables' do
    it 'return the variables' do
      variables = {
        var1: Support::Build.variable_content(value: 'val1'),
        var2: Support::Build.variable_content(value: 'val1')
      }
      plan = described_class.new(
        Support::Build.plan_content({ variables: variables })
      )

      expect(plan.variables).to(eq(variables))
    end
  end

  describe '#variable_values' do
    it 'return a map of variable values' do
      variables = {
        var1: Support::Build.variable_content(value: 'val1'),
        var2: Support::Build.variable_content(value: 'val2')
      }
      plan = described_class.new(
        Support::Build.plan_content({ variables: variables })
      )

      expect(plan.variable_values)
        .to(eq({
                 var1: 'val1',
                 var2: 'val2'
               }))
    end
  end

  describe '#resource_changes' do
    it 'returns a resource change model for each of the resource changes' do
      resource_change_content1 = Support::Build.resource_change_content
      resource_change_content2 = Support::Build.resource_change_content

      plan = described_class.new(
        Support::Build.plan_content(
          {
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          }
        )
      )

      expect(plan.resource_changes)
        .to(contain_exactly(
              RubyTerraform::Models::ResourceChange
                .new(resource_change_content1),
              RubyTerraform::Models::ResourceChange
                .new(resource_change_content2)
            ))
    end
  end

  describe '#output_changes' do
    it 'returns an output change model for each of the output changes' do
      output_name1 = Support::Random.output_name
      output_name2 = Support::Random.output_name
      output_change_content1 = Support::Build.output_change_content
      output_change_content2 = Support::Build.output_change_content

      plan = described_class.new(
        Support::Build.plan_content(
          output_changes: {
            output_name1 => output_change_content1,
            output_name2 => output_change_content2
          }
        )
      )

      expect(plan.output_changes)
        .to(contain_exactly(
              RubyTerraform::Models::OutputChange
                .new(output_name1, output_change_content1),
              RubyTerraform::Models::OutputChange
                .new(output_name2, output_change_content2)
            ))
    end
  end

  describe '#resource_changes_matching' do
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

        plan = described_class.new(
          Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
        )

        resource_changes =
          plan.resource_changes_matching(type: 'some_resource_type')

        expect(resource_changes).to(eq([]))
      end

      it 'returns an empty array when no resource changes' do
        plan = described_class.new(
          Support::Build.plan_content(
            resource_changes: []
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2,
              resource_change_content3
            ]
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            resource_changes: [
              resource_change_content1,
              resource_change_content2
            ]
          )
        )

        resource_changes =
          plan.resource_changes_matching(
            type: 'some_resource_type',
            name: 'some_resource_name'
          )

        expect(resource_changes).to(eq([]))
      end

      it 'returns an empty array when no create resource changes' do
        plan = described_class.new(
          Support::Build.plan_content(
            resource_changes: []
          )
        )

        resource_changes =
          plan.resource_changes_matching(
            type: 'some_resource_type',
            name: 'some_instance'
          )

        expect(resource_changes).to(eq([]))
      end
    end
  end

  describe '#output_changes_matching' do
    describe 'for name' do
      it 'returns output change with matching name in array' do
        output_name1 = Support::Random.output_name
        output_name2 = Support::Random.output_name
        output_change_content1 = Support::Build.output_change_content
        output_change_content2 = Support::Build.output_change_content

        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
        )

        output_changes =
          plan.output_changes_matching(name: output_name3)

        expect(output_changes).to(eq([]))
      end

      it 'returns an empty array when there are no output changes' do
        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {}
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
        )

        output_changes =
          plan.output_changes_matching(delete?: true)

        expect(output_changes).to(eq([]))
      end

      it 'returns an empty array when there are no output changes' do
        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {}
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2,
              output_name3 => output_change_content3
            }
          )
        )

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

        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {
              output_name1 => output_change_content1,
              output_name2 => output_change_content2
            }
          )
        )

        output_changes =
          plan.output_changes_matching(name: output_name3, create?: true)

        expect(output_changes).to(eq([]))
      end

      it 'returns an empty array when there are no output changes' do
        plan = described_class.new(
          Support::Build.plan_content(
            output_changes: {}
          )
        )

        output_changes =
          plan.output_changes_matching(
            name: Support::Random.output_name, create?: true
          )

        expect(output_changes).to(eq([]))
      end
    end
  end

  describe '#inspect' do
    it 'inspects the underlying content' do
      plan_content = Support::Build.plan_content
      plan = described_class.new(plan_content)

      expect(plan.inspect).to(eq(plan_content.inspect))
    end
  end

  describe '#to_h' do
    it 'returns the underlying content' do
      plan_content = Support::Build.plan_content
      plan = described_class.new(plan_content)

      expect(plan.to_h).to(eq(plan_content))
    end
  end
end
