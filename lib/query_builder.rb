require_relative './database'
require_relative './criteria/base'
require_relative './criteria/collection'
require_relative './criteria/query_action'
require_relative './criteria/builder'

module Oriental
  class QueryBuilder
    attr_accessor :criteria
    include Oriental::Criteria::Collection
    include Oriental::Criteria::Builder
    include Oriental::Criteria::QueryAction
    include Oriental::Criteria::Base

    def initialize(klass, crit = nil)
      crit ||= {
        conditions: [],
        target: [], 
        prefetch: [], 
        params: {}, 
        fields: [], 
        from: [],
        order: {},
        limit: [],
        group: [],
        skip: [],
        let: [],
        fields: []
      }
      @klass = klass
      @criteria = crit
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

# # LET $temp = address.city
# q = Oriental::QueryBuilder.new('Post')
# q.select(:$temp).let(:$temp => 'address.city').where(:$temp => "Rumia")
# p q.build_sql

# # let $temp = (
# #       select @rid, $depth from (
# #         traverse V.out, E.in from $parent.current
# #       )
# #       where @class = 'Concept' and (id = 'first concept' or id = 'second concept' )
# #     )

# q = Oriental::QueryBuilder.new("Post")
# q.target(['#11:2', '#11:3']).group_by(:name)
# p q.build_sql

# q = Oriental::QueryBuilder.new('Post')
# q.let(:$temp => proc { target(proc { select(:@rid).to_s}).to_s})
# p q.to_s








