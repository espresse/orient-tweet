module Oriental
  module Builder
    module Query

      def to_s
        build_sql
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
        # p sql_cleanup(result)
        sql_cleanup(result)
      end

      private

      def sql_cleanup(sql)
        sql.gsub(/"(?<rid>#?\d+:\d+)"/, '\k<rid>')
      end

      def prepare_target
        list = criteria[:target].join(', ')
        list = "[#{list}]" if criteria[:target].length > 1
        list
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

      def prepare_order
        res = []
        criteria[:order].each do |entity|
          entity.each {|name, ord| res << "#{name} #{ord}" }
        end
        res.join(', ')
      end

      def prepare_limit
        criteria[:limit].first.to_s
      end

      def prepare_skip
        criteria[:skip].first.to_s
      end

      def prepare_set
        criteria[:set].join(', ')
      end

    end
  end
end
