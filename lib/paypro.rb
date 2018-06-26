require "forwardable"
require "svc/yaml"
require "svc/striim"
require "paypro/version"
require "paypro_error"

class Paypro

  extend Forwardable

  attr_accessor :type, :source_id, :source

  subs = %i(issue issues create update open close create_comment update_comment)
  delegate subs => :source

  def initialize(type, id, opts = {}) #
    @type = type.to_sym
    @source_id = id
    @source = case @type
      when :yaml   then Svc::Yaml.new(id, opts)
      when :striim then Svc::Striim.new(id, opts)
      else
        raise PayproError::InvalidSvcType, "Invalid Svc Type (#{type})"
    end
  end

  class << self
    def hexid_for(issue)
      issue["body"][/(^| |>)\/(\h\h\h\h\h\h)($| |<)/, 2]
    end
  end
end

