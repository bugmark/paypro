require 'ext/hash'
require 'yaml'
require 'securerandom'
require_relative './base'

module Svc
  class Yaml < Base

    attr_accessor :repo_data, :data_file

    def initialize(data_file, _opts = {})
      @data_file = File.expand_path(data_file)
      @repo_data = if File.exist?(data_file)
        YAML.load_file(data_file)
      else
        File.open(data_file, 'w') {|f| f.puts [].to_yaml}
        []
      end
    end

    def issues
      repo_data.map {|el| convert(el)}
    end

    def create(title, body, opts = {})
      next_seq = repo_data.length + 1
      new_item = new_issue(next_seq, title, body, opts)
      repo_data << new_item
      File.open(data_file, 'w') {|f| f.puts repo_data.to_yaml}
      convert(new_item)
    end

    def update(issue_sequence, opts)
      tgt = @repo_data.select {|el| el["sequence"].to_s == issue_sequence.to_s}.first || {}
      lcl = @repo_data.select {|el| el["sequence"].to_s != issue_sequence.to_s} + [tgt.merge(opts)]
      @repo_data = lcl.sort_by {|el| el["sequence"]}
      File.open(data_file, 'w') {|f| f.puts @repo_data.to_yaml}
    end

    def close(issue_sequence)
      update(issue_sequence, {"status" => "closed"})
    end

    def open(issue_sequence)
      update(issue_sequence, {"status" => "open"})
    end

    def create_comment(issue_sequence, body)
      tgt = @repo_data.select {|el| el["sequence"] == issue_sequence}.first || {}
      cls = tgt.fetch("comments", [])
      com = new_comment(tgt, body)
      cls << com
      update(issue_sequence, {"comments" => cls})
    end

    def update_comment(comment_exid, body)
      cls = repo_data.reduce([]) {|acc, v| acc + v.fetch("comments", [])}
      com = cls.select {|el| el["exid"] == comment_exid}.first
      return if com.nil?
      seq = com["issue_sequence"]
      tgt = repo_data.select {|el| el["sequence"] == seq}.first
      nco = tgt.fetch("comments", []).map do |el|
        if el["exid"] == comment_exid
          el["body"] = body
          el
        else
          el
        end
      end
      update(seq, {comments: nco})
    end

    private

    def convert(el)
      el
        .stringify_keys
        .map_keys(Paypro::Issue.mappings)
        .only(*Paypro::Issue.fields)
    end

    def new_issue(seq, title, body, opts = {})
      defaults = {"status" => "open", "exid" => SecureRandom.hex(3)}
      base     = {"title" => title, "body" => body, "sequence" => seq}
      defaults.merge(base).merge(opts)
    end

    def new_comment(tgt, body, author = "NA")
      {"exid" => SecureRandom.hex(3), "body" => body,
       "author" => author, "issue_sequence" => tgt["sequence"]}
    end

  end
end
