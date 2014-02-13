module Oriental
  module Criteria
    module Builder

      def to_s
        p criteria[:params]
        query = "SELECT "
        query += "#{criteria[:fields]} " unless criteria[:fields].empty?
        query += "#{criteria[:from] || @klass} "
        query += "WHERE (#{criteria[:conditions].join(' AND ')})" unless criteria[:conditions].empty?
        query
      end


      def build_sql
        result = ""
        query = self.send "#{query_type.downcase}_query"
        result = query.shift[:query].gsub('?', criteria[:query].to_s)
        query.each do |q|
          key, val = q.shift
          if criteria[key] and not criteria[key].empty?
            result += " " + val.gsub('?', self.send("prepare_#{key}"))
          end
        end
        result
      end

      private

      

      def prepare_target
        criteria[:target].join(', ')
      end

      def prepare_let
        criteria[:let].join(', ')
      end

      def prepare_where
        criteria[:conditions].join(' AND ')
      end

      def prepare_group
        criteria[:group].first.to_s
      end
      end
  end
end