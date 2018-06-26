require 'yaml'
require 'deep_merge'

class Paypro
  class Config

    RC_PATHS = %w(~/.paypro_rc.yml ./.paypro_rc.yml)

    attr_reader :type, :data

    def initialize(type, opts = {})
      @type = type.to_s
      @data = load_data(opts)
    end

    private

    def method_missing(m, *alt)
      return opts[m.to_s] if opts.has_key?(m.to_s)
      return opts[m.to_sym] if opts.has_key?(m.to_sym)
      nil
    end

    def opts
      data[type]
    end

    def load_data(opts)
      RC_PATHS.reduce({}) do |acc, el|
        path = File.expand_path(el)
        File.exists?(path) ? acc.deep_merge(YAML.load_file(path)) : acc
      end
    end
  end
end