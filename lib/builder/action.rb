module Oriental
  module Builder
    module Action
      def insert
        @query_type = "INSERT"
        @query_command = true
        self
      end

      def update
        query_type "UPDATE"
        @query_command = true
        self
      end

      def delete
        query_type "DELETE"
        @query_command = true
        self
      end

      private
      def query_type(query_type = nil)
        @query_type ||= "SELECT"
      end

      def select_query
        criteria[:fields] += ['@rid, @class'] unless criteria[:fields].empty?
        criteria[:query] = criteria[:fields].join(', ')
        criteria[:target] << @klass if criteria[:target].empty?
        criteria[:where] = criteria[:conditions].join(' AND ')
        [
          {query: "SELECT ?"},
          {target: "FROM ?"},
          {let: "LET ?"},
          {where: "WHERE ?"},
          {group: "GROUP BY ?"},
          {order: "ORDER BY ?"},
          {skip: "SKIP ?"},
          {limit: "LIMIT ?"}
        ]
      end

      def insert_query
        criteria[:query] = '' unless criteria[:query]
        criteria[:target] << @klass if criteria[:target].empty?
        [
          {query: "INSERT"},
          {target: "INTO ?"},
          {let: "LET ?"},
          {set: "SET ?"}
        ]
      end

      # def update_query
      #   [
      #     {query: "UPDATE"},
      #     {target: ":target"},
      #     {set: ":fields"},
      #     {increment: ":number"},
      #     {add: ":item"},
      #     {remove: ":item"},
      #     {put: ":entry"},
      #     {content: ":content"},
      #     {merge: ":merge"},
      #     {lock: "LOCK :lock"},
      #     {upsert: ":upsert"},
      #     {returns: "RETURN :returns"},
      #     {let: "LET :assigments"},
      #     {where: "WHERE :conditions"},
      #     {limit: "LIMIT :limit"}
      #   ]
      # end

      # def delete_query
      #   [
      #     {query: "DELETE"},
      #     {target: "FROM :target"},
      #     {lock: "LOCK :lock"},
      #     {returns: ":returns"},
      #     {let: "LET :assigments"},
      #     {where: "WHERE :conditions"},
      #     {limit: "LIMIT :limit"}
      #   ]
      # end

      # def traverse_query
      #   [
      #     {query: "TRAVERSE"},
      #     {target: "FROM :target"},
      #     {let: "LET :assigments"},
      #     {while_condition: "WHILE :condition"},
      #     {limit: "LIMIT :limit"},
      #     {strategy: "STRATEGY :strategy"}
      #   ]
      # end
    end
  end
end
