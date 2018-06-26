require 'yaml'
require 'deep_merge'

class Paypro
  class Issue
    class << self
      def mappings
        {
          "type"           =>   nil                         ,
          "uuid"           =>   %w(issue_uuid)              ,
          "exid"           =>   nil                         ,
          "sequence"       =>   %w(number)                  ,
          "xfields"        =>   nil                         ,
          "jfields"        =>   nil                         ,
          "stm_issue_uuid" =>   %w(issue_uuid uuid)         ,
          "stm_repo_uuid"  =>   %w(repo_uuid)               ,
          "stm_title"      =>   %w(title name)              ,
          "stm_body"       =>   %w(body)                    ,
          "stm_status"     =>   %w(status)                  ,
          "stm_labels"     =>   %w(labels)                  ,
          "stm_comments"   =>   %w(comments)                ,
          "stm_jfields"    =>   nil                         ,
          "stm_xfields"    =>   nil                         ,
        }
      end

      def fields
        mappings.keys
      end
    end
  end
end