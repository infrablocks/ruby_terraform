# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::Path do
  describe '#length' do
    it 'returns the length of the path' do
      path = described_class.new(%i[a b c])

      length = path.length

      expect(length).to(eq(3))
    end

    it 'excludes nils from the path length' do
      path = described_class.new([:a, nil, :b, nil, :c])

      length = path.length

      expect(length).to(eq(3))
    end

    it 'returns zero if the path is empty' do
      path = described_class.new([])

      length = path.length

      expect(length).to(eq(0))
    end

    it 'returns zero if the path contains only nils' do
      path = described_class.new([nil, nil, nil])

      length = path.length

      expect(length).to(eq(0))
    end
  end

  describe '#empty?' do
    it 'is empty if it has not elements' do
      path = described_class.new(%i[])

      expect(path).to(be_empty)
    end

    it 'is empty if all its elements are nil' do
      path = described_class.new([nil, nil, nil])

      expect(path).to(be_empty)
    end

    it 'is not empty if it contains elements' do
      path = described_class.new(%i[a b c])

      expect(path).not_to(be_empty)
    end
  end

  describe '#references_any_lists?' do
    it 'returns true when the path consists of a single numeric element' do
      path = described_class.new([0])

      expect(path.references_any_lists?).to(be(true))
    end

    it 'returns true when the path consists of multiple numeric elements' do
      path = described_class.new([0, 1, 2])

      expect(path.references_any_lists?).to(be(true))
    end

    it 'returns true when the path consists of numeric and symbol elements' do
      path = described_class.new([:some_attribute, 0])

      expect(path.references_any_lists?).to(be(true))
    end

    it 'returns false when the path is empty' do
      path = described_class.new([])

      expect(path.references_any_lists?).to(be(false))
    end

    it 'returns false when the path consists of only symbol elements' do
      path = described_class.new(%i[a b])

      expect(path.references_any_lists?).to(be(false))
    end
  end

  describe '#references_any_maps?' do
    it 'returns true when the path consists of a single symbol element' do
      path = described_class.new([:some_attribute])

      expect(path.references_any_maps?).to(be(true))
    end

    it 'returns true when the path consists of multiple symbol elements' do
      path = described_class.new(
        %i[some_attribute some_key other_key]
      )

      expect(path.references_any_maps?).to(be(true))
    end

    it 'returns true when the path consists of numeric and symbol elements' do
      path = described_class.new([:some_attribute, 0])

      expect(path.references_any_maps?).to(be(true))
    end

    it 'returns false when the path is empty' do
      path = described_class.new([])

      expect(path.references_any_maps?).to(be(false))
    end

    it 'returns false when the path consists of only numeric elements' do
      path = described_class.new([0, 0])

      expect(path.references_any_maps?).to(be(false))
    end
  end

  describe '#same_parent_collection?' do
    it 'returns true when simple paths are same length and differ only in ' \
       'last element' do
      path1 = described_class.new(%i[a b c])
      path2 = described_class.new(%i[a b d])

      expect(path1.same_parent_collection?(path2)).to(be(true))
    end

    it 'returns true when complex paths are same length and differ only in ' \
       'last element' do
      path1 = described_class.new([:a, 0, :b, 2])
      path2 = described_class.new([:a, 0, :b, 1])

      expect(path1.same_parent_collection?(path2)).to(be(true))
    end

    it 'returns false when simple paths are same length and differ in ' \
       'element other than last element' do
      path1 = described_class.new(%i[a b d])
      path2 = described_class.new(%i[a c d])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns false when complex paths are same length and differ in ' \
       'element other than last element' do
      path1 = described_class.new([:a, 0, :b, 1])
      path2 = described_class.new([:a, 0, :c, 2])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns false when complex paths represent nested lists and ' \
       'paths are same length and the same up to the nested list parts' do
      path1 = described_class.new([:a, :b, 0, 2])
      path2 = described_class.new([:a, :b, 1, 1])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns false when complex paths represent nested lists and ' \
       'paths are same length but different prior to the nested list part' do
      path1 = described_class.new([:a, :b, 0, 2])
      path2 = described_class.new([:a, :c, 1, 1])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns false when simple paths are same length and differ in ' \
       'many elements including last' do
      path1 = described_class.new(%i[a b d])
      path2 = described_class.new(%i[a c e])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns false when complex paths are same length and differ in ' \
       'many elements including last' do
      path1 = described_class.new([:a, 0, :b, 2])
      path2 = described_class.new([:a, 0, :c, 1])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns false when first path shorter than second path ' \
       'even if the same otherwise' do
      path1 = described_class.new(%i[a b])
      path2 = described_class.new(%i[a b e])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns false when second path shorter than first path ' \
       'even if the same otherwise' do
      path1 = described_class.new(%i[a b e])
      path2 = described_class.new(%i[a b])

      expect(path1.same_parent_collection?(path2)).to(be(false))
    end

    it 'returns true when paths are equal' do
      path1 = described_class.new(%i[a b e])
      path2 = described_class.new(%i[a b e])

      expect(path1.same_parent_collection?(path2)).to(be(true))
    end
  end

  describe '#list_indices' do
    it 'returns an empty array when the path does not reference lists' do
      path = described_class.new(%i[some_attribute some_key])

      expect(path.list_indices).to(eq([]))
    end

    it 'returns an array containing a tuple of path index and list index ' \
       'when the path contains a single list reference' do
      path = described_class.new([:a, 0, :b])

      expect(path.list_indices).to(eq([[1, 0]]))
    end

    it 'returns an array containing a tuple of path indices and list indices ' \
       'when the path contains multiple list reference' do
      path = described_class.new([:a, 0, :b, 1])

      expect(path.list_indices).to(eq([[1, 0], [3, 1]]))
    end
  end

  describe '#first' do
    it 'returns the first element in the path' do
      path = described_class.new(%i[a b c])

      expect(path.first).to(eq(:a))
    end

    it 'excludes nils when determining first' do
      path = described_class.new([nil, :a, :b, :c])

      expect(path.first).to(eq(:a))
    end

    it 'returns nil if the path is empty' do
      path = described_class.new([])

      expect(path.first).to(be_nil)
    end

    it 'returns nil if the path contains only nils' do
      path = described_class.new([nil, nil, nil])

      expect(path.first).to(be_nil)
    end
  end

  describe '#last' do
    it 'returns the last element in the path' do
      path = described_class.new(%i[a b c])

      expect(path.last).to(eq(:c))
    end

    it 'excludes nils when determining last' do
      path = described_class.new([:a, :b, :c, nil])

      expect(path.last).to(eq(:c))
    end

    it 'returns nil if the path is empty' do
      path = described_class.new([])

      expect(path.last).to(be_nil)
    end

    it 'returns nil if the path contains only nils' do
      path = described_class.new([nil, nil, nil])

      expect(path.last).to(be_nil)
    end
  end

  describe '#up_to_index' do
    it 'returns the path up to the specified index when the path contains ' \
       'more elements than the specified index' do
      path = described_class.new(
        %i[some_attribute other_attribute some_key]
      )

      expect(path.up_to_index(1))
        .to(eq(described_class.new(
                 %i[some_attribute other_attribute]
               )))
    end

    it 'returns the whole path when the path contains ' \
       'the same number of elements as the specified index' do
      path = described_class.new(
        %i[some_attribute other_attribute some_key]
      )

      expect(path.up_to_index(2))
        .to(eq(described_class.new(
                 %i[some_attribute other_attribute some_key]
               )))
    end

    it 'returns the whole path when the path contains ' \
       'less elements as the specified index' do
      path = described_class.new(
        %i[some_attribute other_attribute some_key]
      )

      expect(path.up_to_index(4))
        .to(eq(described_class.new(
                 %i[some_attribute other_attribute some_key]
               )))
    end
  end

  describe '#append' do
    it 'adds the supplied element to the end of the path' do
      path = described_class.new(%i[some_attribute some_key])

      new_path = path.append(2)

      expect(new_path)
        .to(eq(described_class.new([:some_attribute, :some_key, 2])))
    end

    it 'adds the supplied element to an empty path' do
      path = described_class.new(%i[])

      new_path = path.append(:some_attribute)

      expect(new_path)
        .to(eq(described_class.new([:some_attribute])))
    end

    it 'returns the path unchanged if the element is nil' do
      path = described_class.new(%i[some_attribute some_key])

      new_path = path.append(nil)

      expect(new_path)
        .to(eq(described_class.new(%i[some_attribute some_key])))
    end
  end

  describe '#diff' do
    it 'returns an array of the different sub paths of the provided paths' do
      path1 = described_class.new(%i[a b c])
      path2 = described_class.new(%i[a b d])

      diff = path1.diff(path2)

      expect(diff)
        .to(eq(
              [
                described_class.new(%i[c]),
                described_class.new(%i[d])
              ]
            ))
    end

    it 'returns an array of empty paths if the paths are equal' do
      path1 = described_class.new(%i[a b e])
      path2 = described_class.new(%i[a b e])

      expect(path1.diff(path2))
        .to(eq([described_class.new([]),
                described_class.new([])]))
    end

    it 'allows self to be shorter than other' do
      path1 = described_class.new(%i[a b])
      path2 = described_class.new(%i[a b d])

      diff = path1.diff(path2)

      expect(diff)
        .to(eq(
              [
                described_class.new(%i[]),
                described_class.new(%i[d])
              ]
            ))
    end

    it 'allows self to be longer than other' do
      path1 = described_class.new(%i[a b c d])
      path2 = described_class.new(%i[a b])

      diff = path1.diff(path2)

      expect(diff)
        .to(eq(
              [
                described_class.new(%i[c d]),
                described_class.new(%i[])
              ]
            ))
    end
  end

  describe '#<=>' do
    it 'compares identical simple paths as equal' do
      path1 = described_class.new(%i[a b c])
      path2 = described_class.new(%i[a b c])

      expect(path1 <=> path2).to(eq(0))
    end

    it 'compares identical complex paths as equal' do
      path1 = described_class.new(%i[a 0 c])
      path2 = described_class.new(%i[a 0 c])

      expect(path1 <=> path2).to(eq(0))
    end

    it 'compares empty paths as equal' do
      path1 = described_class.new([])
      path2 = described_class.new([])

      expect(path1 <=> path2).to(eq(0))
    end

    it 'compares self less than other when simple, same length and ' \
       'first different symbol in self is less than in other' do
      path1 = described_class.new(%i[a b c])
      path2 = described_class.new(%i[a b d])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when complex, same length and ' \
       'first different number in self is less than in other' do
      path1 = described_class.new(%i[a b 0])
      path2 = described_class.new(%i[a b 1])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when complex, same length and ' \
       'first difference is numeric in self and symbol in other' do
      path1 = described_class.new([:a, :b, 0])
      path2 = described_class.new(%i[a b d])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when simple, shorter and ' \
       'matching everything in other' do
      path1 = described_class.new(%i[a b])
      path2 = described_class.new(%i[a b d])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when complex, shorter and ' \
       'matching everything in other' do
      path1 = described_class.new(%i[a 0])
      path2 = described_class.new(%i[a 0 d])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when simple, shorter and ' \
       'should come before other' do
      path1 = described_class.new(%i[a a])
      path2 = described_class.new(%i[a b d])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when complex, shorter and ' \
       'should come before other' do
      path1 = described_class.new(%i[a 0])
      path2 = described_class.new(%i[a 1 d])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when simple, longer and ' \
       'should come before other' do
      path1 = described_class.new(%i[a a c])
      path2 = described_class.new(%i[a b])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self less than other when complex, longer and ' \
       'should come before other' do
      path1 = described_class.new(%i[a 0 b])
      path2 = described_class.new(%i[a 1])

      expect(path1 <=> path2).to(eq(-1))
    end

    it 'compares self greater than other when simple, same length and ' \
       'first different symbol in self is greater than in other' do
      path1 = described_class.new(%i[a b d])
      path2 = described_class.new(%i[a b c])

      expect(path1 <=> path2).to(eq(1))
    end

    it 'compares self great than other when complex, same length and ' \
       'first difference is symbol in self and numeric in other' do
      path1 = described_class.new(%i[a b d])
      path2 = described_class.new([:a, :b, 0])

      expect(path1 <=> path2).to(eq(1))
    end

    it 'compares self greater than other when complex, same length and ' \
       'first different number in self is greater than in other' do
      path1 = described_class.new(%i[a b 2])
      path2 = described_class.new(%i[a b 1])

      expect(path1 <=> path2).to(eq(1))
    end

    it 'compares self greater than other when simple, shorter and ' \
       'should come after other' do
      path1 = described_class.new(%i[a c])
      path2 = described_class.new(%i[a b d])

      expect(path1 <=> path2).to(eq(1))
    end

    it 'compares self greater than other when complex, shorter and ' \
       'should come after other' do
      path1 = described_class.new(%i[a 2])
      path2 = described_class.new(%i[a 1 d])

      expect(path1 <=> path2).to(eq(1))
    end

    it 'compares self greater than other when simple, longer and ' \
       'matching everything in other' do
      path1 = described_class.new(%i[a b d])
      path2 = described_class.new(%i[a b])

      expect(path1 <=> path2).to(eq(1))
    end

    it 'compares self greater than other when complex, longer and ' \
       'matching everything in other' do
      path1 = described_class.new(%i[a 0 d])
      path2 = described_class.new(%i[a 0])

      expect(path1 <=> path2).to(eq(1))
    end
  end

  describe '#==' do
    it 'returns true when the elements and class are the same' do
      path1 = described_class.new([0, 1])
      path2 = described_class.new([0, 1])

      expect(path1).to(eq(path2))
    end

    it 'returns false when the elements are different' do
      path1 = described_class.new([:a, 0])
      path2 = described_class.new([:a, 1])

      expect(path1).not_to(eq(path2))
    end

    it 'returns false when the classes are different' do
      path1 = described_class.new([:a, 0])
      path2 = Class.new(described_class)
                   .new([:a, 0])

      expect(path1).not_to(eq(path2))
    end
  end

  describe '#hash' do
    it 'has the same result when the elements and class are the same' do
      path1 = described_class.new([0, 1])
      path2 = described_class.new([0, 1])

      expect(path1.hash).to(eq(path2.hash))
    end

    it 'has a different result when the elements are different' do
      path1 = described_class.new([:a, 0])
      path2 = described_class.new([:a, 1])

      expect(path1.hash).not_to(eq(path2.hash))
    end

    it 'has a different result when the classes are different' do
      path1 = described_class.new([:a, 0])
      path2 = Class.new(described_class).new([:a, 0])

      expect(path1.hash).not_to(eq(path2.hash))
    end
  end
end
