module Oriental
  module Criteria
    module QueryAction
      def insert
        query_type "INSERT"
      end

      def update
        query_type "UPDATE"
      end

      def delete
        query_type "DELETE"
      end

      private
      def query_type(query_type = nil)
        @query_type ||= "SELECT"
      end

      def select_query
        criteria[:query] = '' unless criteria[:query]
        criteria[:target] << @klass unless criteria[:target]
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
        [
          {query: "INSERT"},
          {target: "INTO :target"},
          {let: "LET :assigments"},
          {set: ":values"}
        ]
      end

      def update_query
        [
          {query: "UPDATE"},
          {target: ":target"},
          {set: ":fields"},
          {increment: ":number"},
          {add: ":item"},
          {remove: ":item"},
          {put: ":entry"},
          {content: ":content"},
          {merge: ":merge"},
          {lock: "LOCK :lock"},
          {upsert: ":upsert"},
          {returns: "RETURN :returns"},
          {let: "LET :assigments"},
          {where: "WHERE :conditions"},
          {limit: "LIMIT :limit"}
        ]
      end

      def delete_query
        [
          {query: "DELETE"},
          {target: "FROM :target"},
          {lock: "LOCK :lock"},
          {returns: ":returns"},
          {let: "LET :assigments"},
          {where: "WHERE :conditions"},
          {limit: "LIMIT :limit"}
        ]
      end

      def traverse_query
        [
          {query: "TRAVERSE"},
          {target: "FROM :target"},
          {let: "LET :assigments"},
          {while_condition: "WHILE :condition"},
          {limit: "LIMIT :limit"},
          {strategy: "STRATEGY :strategy"}
        ]
      end
    end
  end
end