module Svc
  class Base
    def ledgers
      raise "IMPLEMENT IN SUBCLASS"
    end

    def ledger(exid)
      ledgers.select {|x| x["exid"] == exid}.first
    end

    def ledger_by_exid(exid)
      ledger(exid)
    end

    def ledger_hexid(hexid)
      ledgers.select {|x| x["body"] =~ /(^| |>)\/#{hexid}($| |<)/}.first
    end

    def create(title, body, opts = {} )
      raise "IMPLEMENT IN SUBCLASS"
    end

    def update(ledger_id, opts)
      raise "IMPLEMENT IN SUBCLASS"
    end

    def close(ledger_id)
      raise "IMPLEMENT IN SUBCLASS"
    end

    def open(ledger_id)
      raise "IMPLEMENT IN SUBCLASS"
    end

    def create_comment(comment_id, body)
      raise "IMPLEMENT IN SUBCLASS"
    end

    def update_comment(comment_id, body)
      raise "IMPLEMENT IN SUBCLASS"
    end
  end
end