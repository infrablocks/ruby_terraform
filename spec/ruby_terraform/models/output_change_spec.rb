# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::OutputChange do
  describe '#name' do
    it 'returns the output name' do
      name = Support::Random.output_name
      output_change = described_class.new(
        name, Support::Build.output_change_content
      )

      expect(output_change.name).to(eq(name))
    end
  end

  describe '#change' do
    it 'returns a RubyTerraform::Models::Change for the output change' do
      content = Support::Build.output_change_content
      output_change = described_class.new(
        Support::Random.output_name, content
      )

      expect(output_change.change).to(eq(M::Change.new(content)))
    end
  end

  describe '#create?' do
    it 'returns true if the change represents a create' do
      output_change_content = Support::Build.create_change_content(
        {}, { type: :output }
      )
      output_change = described_class.new(
        Support::Random.output_name,
        output_change_content
      )

      expect(output_change.create?)
        .to(be(true))
    end

    {
      'update' => Support::Build.update_change_content(
        {}, { type: :output }
      ),
      'delete' => Support::Build.delete_change_content(
        {}, { type: :output }
      )
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        output_change_content = entry[1]
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.create?)
          .to(be(false))
      end
    end
  end

  describe '#update?' do
    it 'returns true if the change represents an update' do
      output_change_content = Support::Build.update_change_content(
        {}, { type: :output }
      )
      output_change = described_class.new(
        Support::Random.output_name,
        output_change_content
      )

      expect(output_change.update?)
        .to(be(true))
    end

    {
      'create' => Support::Build.create_change_content(
        {}, { type: :output }
      ),
      'delete' => Support::Build.delete_change_content(
        {}, { type: :output }
      )
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        output_change_content = entry[1]
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.update?)
          .to(be(false))
      end
    end
  end

  describe '#delete?' do
    it 'returns true if the change represents a delete' do
      output_change_content = Support::Build.delete_change_content(
        {}, { type: :output }
      )
      output_change = described_class.new(
        Support::Random.output_name,
        output_change_content
      )

      expect(output_change.delete?)
        .to(be(true))
    end

    {
      'create' => Support::Build.create_change_content(
        {}, { type: :output }
      ),
      'update' => Support::Build.update_change_content(
        {}, { type: :output }
      )
    }.each do |entry|
      it "returns false if the change represents a #{entry[0]}" do
        output_change_content = entry[1]
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.delete?)
          .to(be(false))
      end
    end
  end

  describe '#present_before?' do
    {
      'update' => Support::Build.update_change_content(
        {}, { type: :output }
      ),
      'delete' => Support::Build.delete_change_content(
        {}, { type: :output }
      )
    }.each do |entry|
      it "returns true if the change represents a #{entry[0]}" do
        output_change_content = entry[1]
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.present_before?)
          .to(be(true))
      end
    end

    it 'returns false if the change represents a create' do
      output_change_content = Support::Build.create_change_content(
        {}, { type: :output }
      )
      output_change = described_class.new(
        Support::Random.output_name,
        output_change_content
      )

      expect(output_change.present_before?)
        .to(be(false))
    end
  end

  describe '#present_after?' do
    {
      'create' => Support::Build.create_change_content(
        {}, { type: :output }
      ),
      'update' => Support::Build.update_change_content(
        {}, { type: :output }
      )
    }.each do |entry|
      it "returns true if the change represents a #{entry[0]}" do
        output_change_content = entry[1]
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.present_after?)
          .to(be(true))
      end
    end

    it 'returns false if the change represents a delete' do
      output_change_content = Support::Build.delete_change_content(
        {}, { type: :output }
      )
      output_change = described_class.new(
        Support::Random.output_name,
        output_change_content
      )

      expect(output_change.present_after?)
        .to(be(false))
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name, content)
      value2 = described_class.new(name, content)

      expect(value1).to(eq(value2))
    end

    it 'returns false when the name is different' do
      name1 = Support::Random.output_name
      name2 = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name1, content)
      value2 = described_class.new(name2, content)

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the content is different' do
      name = Support::Random.output_name
      content1 = Support::Build.output_change_content(
        after: Support::Random.alphanumeric_string
      )
      content2 = Support::Build.output_change_content(
        after: Support::Random.alphanumeric_string
      )

      value1 = described_class.new(name, content1)
      value2 = described_class.new(name, content2)

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name, content)
      value2 = Class.new(described_class).new(name, content)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name, content)
      value2 = described_class.new(name, content)

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the name is different' do
      name1 = Support::Random.output_name
      name2 = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name1, content)
      value2 = described_class.new(name2, content)

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the content is different' do
      name = Support::Random.output_name
      content1 = Support::Build.output_change_content(
        after: Support::Random.alphanumeric_string
      )
      content2 = Support::Build.output_change_content(
        after: Support::Random.alphanumeric_string
      )

      value1 = described_class.new(name, content1)
      value2 = described_class.new(name, content2)

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name, content)
      value2 = Class.new(described_class).new(name, content)

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'inspects the underlying name and content as a hash' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      output_change = described_class.new(name, content)

      expect(output_change.inspect).to(eq({ name => content }.inspect))
    end
  end

  describe '#to_h' do
    it 'returns the underlying name and content in a hash' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      output_change = described_class.new(name, content)

      expect(output_change.to_h).to(eq({ name => content }))
    end
  end
end
