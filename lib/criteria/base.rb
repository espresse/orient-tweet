module Oriental
  module Criteria
    module Base
      def select(*fields)
        criteria[:query] = fields.join(', ')
        self
      end      

      def target(obj)
        if obj.is_a? String
          criteria[:target] << obj
        elsif obj.is_a? Array
          criteria[:target] += obj
        elsif obj.is_a? Proc
          criteria[:target] << Oriental::QueryBuilder.new(@klass).instance_eval(&obj)
        end
        self
      end      

      def prefetch(option)
        criteria[:prefetch] = option
      end

      def find(obj)
        criteria[:from] = obj
        #execute
      end

      def from(obj)
        criteria[:from] = obj
        self
      end

      def find_by(args)
        where(args).first
      end

      def let(args)
        args.each do |key, value|
          if value.is_a? Proc
             criteria[:let] << "(#{key} = " + Oriental::QueryBuilder.new(@klass).instance_eval(&value) + ")"
          else
            criteria[:let] << "(#{key} = #{value})"
          end
        end
        self
      end

      def execute
        Oriental::Database.instance.database.query(build_sql, criteria[:params], "*:0")
      end
    end
  end
end