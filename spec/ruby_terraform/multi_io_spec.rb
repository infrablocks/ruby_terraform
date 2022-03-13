# frozen_string_literal: true

require 'logger'
require 'spec_helper'

describe RubyTerraform::MultiIO do
  describe '#write' do
    it 'writes to a single passed IO' do
      io = StringIO.new
      multi_io = described_class.new(io)

      multi_io.write("Hello world!\n")
      multi_io.write("This should be written\n")

      expect(io.string)
        .to(eq("Hello world!\nThis should be written\n"))
    end

    it 'writes to multiple passed IOs' do
      io1 = StringIO.new
      io2 = StringIO.new
      io3 = StringIO.new
      multi_io = described_class.new(io1, io2, io3)

      multi_io.write("Hello world!\n")
      multi_io.write("This should be written\n")

      expect([io1.string, io2.string, io3.string])
        .to(all(eq("Hello world!\nThis should be written\n")))
    end

    it 'allows multiple arguments to be passed to write' do
      io1 = StringIO.new
      io2 = StringIO.new
      multi_io = described_class.new(io1, io2)

      multi_io.write("Hello world!\n", "This should be written\n")

      expect([io1.string, io2.string])
        .to(all(eq("Hello world!\nThis should be written\n")))
    end
  end

  describe '#close' do
    it 'closes a single passed IO' do
      io = StringIO.new
      multi_io = described_class.new(io)

      multi_io.close

      expect(io.closed?).to(be(true))
    end

    it 'closes multiple passed IOs' do
      io1 = StringIO.new
      io2 = StringIO.new
      io3 = StringIO.new
      multi_io = described_class.new(io1, io2, io3)

      multi_io.close

      expect([io1.closed?, io2.closed?, io3.closed?])
        .to(all(be(true)))
    end
  end

  describe '#reopen' do
    it 'reopens a single passed IO' do
      io1 = StringIO.new
      io2 = StringIO.new

      io1.close

      multi_io = described_class.new(io1)

      multi_io.reopen(io2)

      expect(io1.closed?).to(be(false))
    end

    it 'reopens multiple passed IOs' do
      io1 = StringIO.new
      io2 = StringIO.new
      io3 = StringIO.new
      io4 = StringIO.new

      io1.close
      io2.close
      io3.close

      multi_io = described_class.new(io1, io2, io3)

      multi_io.reopen(io4)

      expect([io1.closed?, io2.closed?, io3.closed?])
        .to(all(be(false)))
    end

    it 'allows multiple arguments to be passed to reopen' do
      io1 = StringIO.new
      io2 = StringIO.new

      io1.close
      io2.close

      multi_io = described_class.new(io1, io2)

      multi_io.reopen('Hello', 'r')

      expect([io1.closed?, io2.closed?])
        .to(all(be(false)))
    end
  end
end
