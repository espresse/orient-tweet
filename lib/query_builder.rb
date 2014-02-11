module Oriental
  class QueryBuilder

    def initialize(klass, crit = {conditions: {}, prefetch: "*:0"})
      @klass = klass
      @criteria = crit
    end

    def prefetch(option)
      @criteria[:prefetch] = option
    end

    # User.find_by(name: "name")
    def find_by(args)
      conditions = []
      params.each do |key, value|
        conditions << "#{key} = :#{key}"
      end
      { query: "select from #{@klass.to_s} where #{conditions.join(' and ')} limit 1", params: args, prefetch: @criteria[:prefetch]}
    end

    # Record.find('#12:1')
    def find(obj)
      { query: "select from :rid", params: {rid: obj} }
    end
  end
end
