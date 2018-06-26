module Svc
  class Base
    def collect(user_params)
      raise "IMPLEMENT IN SUBCLASS"
    end

    def distribute(user_params)
      raise "IMPLEMENT IN SUBCLASS"
    end

    def payment_pool
      raise "IMPLEMENT IN SUBCLASS"
    end
  end
end