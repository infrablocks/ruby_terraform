require 'logger'
require 'spec_helper'

describe RubyTerraform::MultiIO do
  subject(:multi_io) { described_class.new(log_file1, log_file2) }

  let(:log_file1) { instance_double(Logger::LogDevice, write: nil, close: nil) }
  let(:log_file2) { instance_double(Logger::LogDevice, write: nil, close: nil) }
  let(:logger) { Logger.new(multi_io, level: :debug) }

  context 'when configured with multiple log_file targets' do
    before do
      allow(Open4).to receive(:spawn)
      allow(RubyTerraform::Commands::Refresh).to receive(:new).and_call_original
      RubyTerraform.configure do |config|
        config.binary = '/binary/path/terraform'
        config.logger = logger
        config.stdout = logger
        config.stderr = logger
      end
      RubyTerraform.refresh
      RubyTerraform.reset!
    end

    it 'writes log messages to the first log file target' do
      expect(log_file1).to have_received(:write).with(%r{Running '/binary/path/terraform refresh'})
    end

    it 'writes log messages to the second file target' do
      expect(log_file2).to have_received(:write).with(%r{Running '/binary/path/terraform refresh'})
    end

    describe '#close' do
      before { multi_io.close }

      it 'closes the first log file target' do
        expect(log_file1).to have_received(:close)
      end

      it 'closes the second log file target' do
        expect(log_file2).to have_received(:close)
      end
    end
  end
end
