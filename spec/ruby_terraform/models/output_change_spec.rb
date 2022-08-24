# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::OutputChange do
  describe '#name' do
    it 'returns the output name as a string when provided as a symbol' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content
      output_change = described_class.new(name.to_sym, content)

      expect(output_change.name).to(eq(name.to_s))
    end

    it 'returns the output name as a string when provided as a string' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content
      output_change = described_class.new(name, content)

      expect(output_change.name).to(eq(name.to_s))
    end
  end

  describe '#change' do
    it 'returns a RubyTerraform::Models::Change for the output change ' \
       'when content has symbols for keys' do
      content = Support::Build.output_change_content
      content = Support::Transform.symbolise_keys(content)
      output_change = described_class.new(
        Support::Random.output_name, content
      )

      expect(output_change.change).to(eq(M::Change.new(content)))
    end

    it 'returns a RubyTerraform::Models::Change for the output change ' \
       'when content has strings for keys' do
      content = Support::Build.output_change_content
      content = Support::Transform.stringify_keys(content)
      output_change = described_class.new(
        Support::Random.output_name, content
      )

      expect(output_change.change).to(eq(M::Change.new(content)))
    end
  end

  describe '#no_op?' do
    context 'when content has symbols for keys' do
      it 'returns true if the change represents no change' do
        output_change_content = Support::Build.no_op_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.symbolise_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.no_op?)
          .to(be(true))
      end

      {
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.symbolise_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.no_op?)
            .to(be(false))
        end
      end
    end

    context 'when content has strings for keys' do
      it 'returns true if the change represents no change' do
        output_change_content = Support::Build.no_op_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.stringify_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.no_op?)
          .to(be(true))
      end

      {
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.stringify_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.no_op?)
            .to(be(false))
        end
      end
    end
  end

  describe '#create?' do
    context 'when content has symbols for keys' do
      it 'returns true if the change represents a create' do
        output_change_content = Support::Build.create_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.symbolise_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.create?)
          .to(be(true))
      end

      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.symbolise_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.create?)
            .to(be(false))
        end
      end
    end

    context 'when content has strings for keys' do
      it 'returns true if the change represents a create' do
        output_change_content = Support::Build.create_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.stringify_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.create?)
          .to(be(true))
      end

      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.stringify_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.create?)
            .to(be(false))
        end
      end
    end
  end

  describe '#update?' do
    context 'when content has symbols for keys' do
      it 'returns true if the change represents an update' do
        output_change_content = Support::Build.update_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.symbolise_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.update?)
          .to(be(true))
      end

      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.symbolise_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.update?)
            .to(be(false))
        end
      end
    end

    context 'when content has strings for keys' do
      it 'returns true if the change represents an update' do
        output_change_content = Support::Build.update_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.stringify_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.update?)
          .to(be(true))
      end

      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.stringify_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.update?)
            .to(be(false))
        end
      end
    end
  end

  describe '#delete?' do
    context 'when content has symbols for keys' do
      it 'returns true if the change represents a delete' do
        output_change_content = Support::Build.delete_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.symbolise_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.delete?)
          .to(be(true))
      end

      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.symbolise_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.delete?)
            .to(be(false))
        end
      end
    end

    context 'when content has strings for keys' do
      it 'returns true if the change represents a delete' do
        output_change_content = Support::Build.delete_change_content(
          {}, { type: :output }
        )
        output_change_content =
          Support::Transform.stringify_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.delete?)
          .to(be(true))
      end

      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns false if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.stringify_keys(output_change_content)
          output_change = described_class.new(
            Support::Random.output_name,
            output_change_content
          )

          expect(output_change.delete?)
            .to(be(false))
        end
      end
    end
  end

  describe '#present_before?' do
    context 'when content has symbols for keys' do
      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns true if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.symbolise_keys(output_change_content)
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
        output_change_content =
          Support::Transform.symbolise_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.present_before?)
          .to(be(false))
      end
    end

    context 'when content has strings for keys' do
      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        ),
        'delete' => Support::Build.delete_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns true if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.stringify_keys(output_change_content)
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
        output_change_content =
          Support::Transform.stringify_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.present_before?)
          .to(be(false))
      end
    end
  end

  describe '#present_after?' do
    context 'when content has symbols for keys' do
      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns true if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.symbolise_keys(output_change_content)
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
        output_change_content =
          Support::Transform.symbolise_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.present_after?)
          .to(be(false))
      end
    end

    context 'when content has strings for keys' do
      {
        'no-op' => Support::Build.no_op_change_content(
          {}, { type: :output }
        ),
        'create' => Support::Build.create_change_content(
          {}, { type: :output }
        ),
        'update' => Support::Build.update_change_content(
          {}, { type: :output }
        )
      }.each do |entry|
        it "returns true if the change represents a #{entry[0]}" do
          output_change_content = entry[1]
          output_change_content =
            Support::Transform.stringify_keys(output_change_content)
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
        output_change_content =
          Support::Transform.stringify_keys(output_change_content)
        output_change = described_class.new(
          Support::Random.output_name,
          output_change_content
        )

        expect(output_change.present_after?)
          .to(be(false))
      end
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same and state ' \
       'uses symbols for keys' do
      name = Support::Random.output_name.to_sym
      content = Support::Build.output_change_content
      content = Support::Transform.symbolise_keys(content)

      value1 = described_class.new(name, content)
      value2 = described_class.new(name, content)

      expect(value1).to(eq(value2))
    end

    it 'returns true when the state and class are the same and state ' \
       'uses strings for keys' do
      name = Support::Random.output_name.to_s
      content = Support::Build.output_change_content
      content = Support::Transform.stringify_keys(content)

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

    it 'returns true when the name is the same but one is a symbol ' \
       'and the other is a string' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name.to_sym, content)
      value2 = described_class.new(name.to_s, content)

      expect(value1).to(eq(value2))
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

    it 'returns true when the content is the same but one ' \
       'uses symbol keys and the other uses string keys' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(
        name, Support::Transform.symbolise_keys(content)
      )
      value2 = described_class.new(
        name, Support::Transform.stringify_keys(content)
      )

      expect(value1).to(eq(value2))
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
    it 'has the same result when the state and class are the same and state ' \
       'uses symbols for keys' do
      name = Support::Random.output_name.to_sym
      content = Support::Build.output_change_content
      content = Support::Transform.symbolise_keys(content)

      value1 = described_class.new(name, content)
      value2 = described_class.new(name, content)

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has the same result when the state and class are the same and state ' \
       'uses strings for keys' do
      name = Support::Random.output_name.to_s
      content = Support::Build.output_change_content
      content = Support::Transform.stringify_keys(content)

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

    it 'has the same result when the name is the same but one is a symbol ' \
       'and the other is a string' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(name.to_sym, content)
      value2 = described_class.new(name.to_s, content)

      expect(value1.hash).to(eq(value2.hash))
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

    it 'has the same result when the content is the same but one ' \
       'uses symbol keys and the other uses string keys' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content

      value1 = described_class.new(
        name, Support::Transform.symbolise_keys(content)
      )
      value2 = described_class.new(
        name, Support::Transform.stringify_keys(content)
      )

      expect(value1.hash).to(eq(value2.hash))
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
    it 'inspects the underlying name and content as a hash ' \
       'with symbol keys when state has symbol keys' do
      name = Support::Random.output_name.to_sym
      content = Support::Build.output_change_content
      content = Support::Transform.symbolise_keys(content)

      output_change = described_class.new(name, content)

      expect(output_change.inspect).to(eq({ name.to_sym => content }.inspect))
    end

    it 'inspects the underlying name and content as a hash ' \
       'with symbol keys when state has string keys' do
      name = Support::Random.output_name.to_s
      content = Support::Build.output_change_content
      stringified_content = Support::Transform.stringify_keys(content)
      symbolised_content = Support::Transform.symbolise_keys(content)

      output_change = described_class.new(name, stringified_content)

      expect(output_change.inspect)
        .to(eq({ name.to_sym => symbolised_content }.inspect))
    end
  end

  describe '#to_h' do
    it 'returns the underlying name and content in a hash ' \
       'with symbols as keys when state has symbol keys' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content
      symbolised_content = Support::Transform.symbolise_keys(content)

      output_change = described_class.new(name.to_sym, symbolised_content)

      expect(output_change.to_h).to(eq({ name.to_sym => symbolised_content }))
    end

    it 'returns the underlying name and content in a hash ' \
       'with symbols as keys when state has string keys' do
      name = Support::Random.output_name
      content = Support::Build.output_change_content
      stringified_content = Support::Transform.stringify_keys(content)
      symbolised_content = Support::Transform.symbolise_keys(content)

      output_change = described_class.new(name.to_s, stringified_content)

      expect(output_change.to_h).to(eq({ name.to_sym => symbolised_content }))
    end
  end
end
