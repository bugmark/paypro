require 'ext/array'
require 'ext/hash'
require 'octokit'
require 'paypro/config'
require 'paypro/issue'
require 'paypro/comment'
require_relative './base'

module Svc
  class Striim < Base

    attr_accessor :repo_name, :repo_issues, :repo_comments
    attr_reader :normalized_issues, :normalized_comments, :lcl_opts

    # opts: state: "open" | "closed" | "all" (default)
    # labels: <comma separated list>
    def initialize(name, opts = {})
      configure_octokit
      Octokit.auto_paginate = true
      @lcl_opts = {per_page: 100, state: "all"}.merge(opts)
      @repo_name = name
      @repo_issues   = Octokit.issues(repo_name, lcl_opts)
      @repo_comments = Octokit.issues_comments(repo_name)
    end

    def issues
      @normalized_issues   ||= repo_issues.map {|el| normalize_issue(el)}
      @normalized_comments ||= repo_comments.map {|el| normalize_comment(el)}
      @lcl_issues ||= combine(normalized_issues, normalized_comments)
    end

    def create(title, body, opts = {})
      result = Octokit.create_issue(repo_name, title, body, opts)
      normalize_issue(result)
    end

    def update(issue_sequence, opts)
      Octokit.update_issue(repo_name, issue_sequence, opts)
    end

    def close(issue_sequence)
      Octokit.close_issue(repo_name, issue_sequence)
    end

    def open(issue_sequence)
      Octokit.reopen_issue(repo_name, issue_sequence)
    end

    def create_comment(issue_sequence, body)
      Octokit.add_comment(repo_name, issue_sequence, body)
    end

    def update_comment(comment_id, body)
      Octokit.update_comment(repo_name, comment_id, body)
    end

    private

    def combine(issues, comments)
      issues.map do |iel|
        iel["stm_comments"] = comments.select do |cel|
          cel["issue_sequence"] == iel["sequence"]
        end
        iel
      end
    end

    def normalize_comment(el)
      lcl_fields = Paypro::Comment.fields
      sel = el.to_hash.stringify_keys
      sel
        .map_keys(Paypro::Comment.mappings)
        .map_keys({"exid" => "id"})
        .merge(comment_fields_for(sel))
        .only(*lcl_fields)
        .without_blanks
    end

    def comment_fields_for(el)
      seq  = el["issue_url"].split("/").last.to_i
      auth = el["user"][:login]
      { "issue_sequence" => seq, "author" => auth }
    end

    def normalize_issue(el)
      lcl_fields = Paypro::Issue.fields + %w(html_url)
      sel = el.to_hash.stringify_keys
      sel
        .map_keys(Paypro::Issue.mappings)
        .map_keys({"stm_status" => "state", "exid" => "id"})
        .merge(labels_for(sel))
        .only(*lcl_fields)
        .without_blanks
    end

    def add_fields(input)
      names = input["labels"].map {|el| el[:name]}
      input["stm_labels"] = names.join(", ")
      input
    end

    def labels_for(el)
      text = el["labels"].map {|x| x[:name]}.join(", ")
      { "stm_labels" => text }
    end

    def configure_octokit
      @octoclient ||= begin
        config = Paypro::Config.new(:github)
        Octokit.configure do |c|
          c.login         = config.username
          c.password      = config.password
        end
      end
    end
  end
end
