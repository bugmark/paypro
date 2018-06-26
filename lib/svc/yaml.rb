require 'ext/array'
require 'ext/hash'
require 'paypro/config'
require_relative './base'

module Svc
  class Yaml < Base

    def initialize(name, opts = {})
    end

    def collect(_params)
      "OK"
    end

    def distribute(_params)
      "OK"
    end

    def pool_balance
      "OK"
    end

    private

    def private_method
      "DO SOMETHING"
    end
  end
end

