module Oriental
  module Builder
    module Base
      def select(*fields)
        criteria[:fields] += fields
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
        from(obj)
        return first if obj.is_a? String
        self
      end

      def from(obj)
        if obj.is_a? String
          criteria[:target] << obj
        elsif obj.is_a? Array
          criteria[:target] += obj
        end
        self
      end

      def set(params)
        params.each do |key, val|
          if val.is_a? Array
            val = val.map {|v| v.is_a?(RecordId) ? v.to_s : v}
          elsif val.is_a? Set
            res = ""
            val.each { |v| res += v.is_a?(RecordId) ? v.to_s : v }
            val = "set(#{res})"
          else
            val = val.is_a?(RecordId) ? val.to_s : val
          end
          criteria[:set] << "#{key}=#{val}"
        end
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

      def each(&block)
        return enum_for(__method__) if block.nil?

        unless @query_command
          result = Oriental::Database.instance.database.query(build_sql, criteria[:params], "*:0")
        else
          result = Oriental::Database.instance.database.command(build_sql, criteria[:params], "*:0")
        end

        collection = result[:collection]
        prefetched = result[:prefetched_records]
        collection.each do |record|
          res = OrientdbBinary::Parser::Deserializer.new.deserialize_document(record[:record_content])
          res[:@rid] = "##{record[:cluster_id]}:#{record[:position]}"

          name = res[:@class] || res[:class]
          unless @return_class_records_only
            if name
              constant = Object
              constant = constant.const_defined?(name) ? constant.const_get(name) : Oriental::Record
            else
              constant = Oriental::Record
            end
            return block.call(constant.new(res))
          end

          if name == @klass.to_s
            constant = Object
            constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)

            return block.call(constant.new(res))
          end

        end
      end
    end
  end
end
