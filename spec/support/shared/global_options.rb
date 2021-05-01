# frozen_string_literal: true

require_relative '../../../lib/ruby_terraform/options/global'
require_relative '../../../lib/ruby_terraform/options/name'

class GlobalOptions
  include RubyTerraform::Options::Global

  def self.each_key(&block)
    new.each_key(&block)
  end

  def each_key
    options.each do |switch|
      yield RubyTerraform::Options::Name.new(switch).as_singular_key
    end
  end
end
