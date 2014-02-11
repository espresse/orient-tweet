module Oriental
  module Document

    def self.included(base)
        base.extend(ClassMethods)
        base.include(Virtus.model)
        base.include(Veto.validator)
        base.include(InstanceMethods)
    end

    module InstanceMethods
      def initialize(record = {})
        self.rid = record[:@rid]
        self.username = record[:name]
        self.crypted_pass = record[:password]
      end

      def new?
        !rid
      end

      def save
        new? ? create : update
      end

      def update
        if valid?
          call_before_actions_for(:update)
        end
      end

      def create
        if valid?
          call_before_actions_for(:create)
        end
      end

      def find
      end

      def where(params)
      end


      def valid?(entity=nil)
        super self
      end

      private

      def call_before_actions_for(name)
        before_actions = self.class.before_actions(name)
        
        before_actions.each { |action| p action; action.is_a?(Proc) ? action.call : self.send(action) } if before_actions and not before_actions.empty?
      end
    end

    module ClassMethods

      def before(name, action)
        if name == :save
          before :create, action
          before :update, action
          return
        end
        @before_actions ||= {}
        @before_actions[name] ||= []
        @before_actions[name] << action
      end

      def before_actions(name)
        @before_actions[name] if @before_actions
      end

      # find_by(username: 'xxx')
      def find_by(params)
        builder = QueryBuilder.new(self).find_by(params)
        entity = ::Database.instance.database.query builder[:query], builder[:params], builder[:prefetch]
        obj = OrientdbBinary::Parser::Deserializer.new.deserialize_document(entity[:collection][0][:record_content])
        
        obj[:@rid] = "#{entity[:collection][0][:cluster_id]}:#{entity[:collection][0][:position]}"
        
      end
    end

  end
end