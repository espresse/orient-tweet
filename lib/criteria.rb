require_relative './database'
require_relative './builder/base'
require_relative './builder/collection'
require_relative './builder/action'
require_relative './builder/query'

module Oriental
  class Criteria
    attr_accessor :criteria, :collection

    include Enumerable
    include Oriental::Builder::Collection
    include Oriental::Builder::Query
    include Oriental::Builder::Action
    include Oriental::Builder::Base

    def initialize(klass, crit = nil)
      crit ||= {
        conditions: [],
        target: [],
        prefetch: [],
        params: {},
        fields: [],
        from: [],
        order: [],
        limit: [],
        group: [],
        skip: [],
        let: [],
        fields: [],
        set: []
      }
      @klass = klass
      @criteria = crit
      @query_command = false
      @return_class_records_only = true
    end
  end

end


# q = Oriental::Criteria.new('Post')
# q.where("name = 'name'", {name: 'x', body: 'y'}, {name: "y", body: 'x'}).where(price: 1..20)
# p q.to_s

# q = Oriental::Criteria.new('Post')
# p q.where(:$is => {name: nil}).to_s

# q = Oriental::Criteria.new('Post').from('12:1')
# p q.where(:$in => {id: [1,2,3]}).where(name: /admin\d*/).to_s

# q = Oriental::Criteria.new('Post')
# p q.where({"name.charAt(0)" => "L"}).to_s

# q = Oriental::Criteria.new('Post')
# p q.where(name: 'L').where(name: 'L').to_s

# # LET $temp = address.city
# q = Oriental::Criteria.new('Post')
# q.select(:$temp).let(:$temp => 'address.city').where(:$temp => "Rumia")
# p q.build_sql

# # let $temp = (
# #       select @rid, $depth from (
# #         traverse V.out, E.in from $parent.current
# #       )
# #       where @class = 'Concept' and (id = 'first concept' or id = 'second concept' )
# #     )

# q = Oriental::Criteria.new("Post")
# q.target(['#11:2', '#11:3']).group_by(:name)
# p q.build_sql

# q = Oriental::Criteria.new('Post')
# q.let(:$temp => proc { target(proc { select(:@rid).to_s}).to_s})
# p q.to_s








