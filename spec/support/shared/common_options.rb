# frozen_string_literal: true

require_relative '../../../lib/ruby_terraform/options/common'
require_relative '../../../lib/ruby_terraform/options/name'

class CommonOptions
  include RubyTerraform::Options::Common

  def self.each_key(&block)
    new.each_key(&block)
  end

  def each_key
    options.each do |switch|
      yield RubyTerraform::Options::Name.new(switch).as_key
    end
  end
end
