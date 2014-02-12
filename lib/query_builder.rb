module Oriental
  class QueryBuilder
    
    def initialize(klass, crit = nil)
      crit ||= {
        conditions: [], 
        prefetch: "*:0", 
        params: {}, 
        fields: [], 
        from: nil,
        order: {},
        limit: nil
      }
      @klass = klass
      @criteria = crit
    end

    def prefetch(option)
      @criteria[:prefetch] = option
    end

    def where(*args)
      or_conditions = []

      args.each do |arg|
        if arg.is_a? String
          or_conditions << arg

        elsif arg.is_a? Hash
          and_conditions = []

          arg.each do |key, value|
            operator, key, value = parse_key_val(key, value)
            and_conditions << hash_condition(operator, key, value)
          end

          or_conditions << "(" + and_conditions.join(' AND ') + ")"
        end
      end
      @criteria[:conditions] << or_conditions.join(' OR ')
      self
    end

    def first
      order rid: :asc
      limit 1
      #execute
    end

    def last
      order rid: :desc
      limit 1
      #execute
    end

    def order(arg)
      @criteria[:order] = arg
      self
    end

    def limit(num)
      @criteria[:limit] = num
      self
    end

    def find(obj)
      @criteria[:from] = obj
      self
    end

    def from(obj)
      @criteria[:from] = obj
      self
    end

    def find_by(args)
      where(args).first
    end

    def to_s
      p @criteria[:params]
      query = "SELECT "
      query += "#{@criteria[:fields]} " unless @criteria[:fields].empty?
      query += "#{@criteria[:from] || @klass} "
      query += "WHERE (#{@criteria[:conditions].join(' AND ')})" unless @criteria[:conditions].empty?
      query
    end

    private

    def parse_key_val(key, value)
      op = operator_for key

      key, value = value.shift if op      
      _op, value = parse_value(value)
      
      op ||= _op      
      return op, key, value
    end

    def operator_for(key)
      operators = [
        "$like", "$is", "=", ">", ">=", "<", "<=", "<>",
        "$between", "$in", "$instanceof", "$contains", 
        "$constainsall", "$containskey", "$containsvalue",
        "$containstext", "$matches"
      ]

      return key.to_s.gsub('$', '').upcase if operators.include?(key.to_s)
      nil
    end

    def parse_value(val)
      return '', nil unless val
      return "BETWEEN", "#{val.begin} AND #{val.end}" if val.is_a? Range
      return "MATCHES", val.source if val.is_a? Regexp
      return "IN", val if val.is_a? Array
      return "=", val
    end

    def unique_params_key
      (rand(36**8).to_s(36)).to_sym
    end

    def update_params_value(key, value)
      unless value == nil
        params_key = key.to_sym

        if key.is_a? String
          params_key = unique_params_key if key =~ /[.,\/()]/
        end

        params_key = unique_params_key if (@criteria[:params][key.to_sym] and not @criteria[:params][key.to_sym] == value)
        @criteria[:params][params_key] = value
        key = params_key
      end
      return key
    end

    def hash_condition(operator, field, value=nil)
      params_key = update_params_value(field, value)

      cond = "#{field} #{operator} "
      cond += (value == nil) ? "null" : ":#{params_key}"
      cond
    end
  end

end


# q = Oriental::QueryBuilder.new('Post')
# q.where("name = 'name'", {name: 'x', body: 'y'}, {name: "y", body: 'x'}).where(price: 1..20)
# p q.to_s

# q = Oriental::QueryBuilder.new('Post')
# p q.where(:$is => {name: nil}).to_s

# q = Oriental::QueryBuilder.new('Post').from('12:1')
# p q.where(:$in => {id: [1,2,3]}).where(name: /admin\d*/).to_s

# q = Oriental::QueryBuilder.new('Post')
# p q.where({"name.charAt(0)" => "L"}).to_s

# q = Oriental::QueryBuilder.new('Post')
# p q.where(name: 'L').where(name: 'L').to_s
