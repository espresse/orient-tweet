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
        # self.rid = Oriental::RecordId(record[:@rid])
        record[:properties] = record.clone
        map = record.map do |k, v|
          if k.to_s[0] == "@"
            [k.to_s[1..-1].to_sym, v]
          else
            [k, v]
          end
        end
        record = Hash[map]
        super(record)
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

      def find_by(params)
        Oriental::Criteria.new(self).find_by(params)
      end

      def find(obj)
        Oriental::Criteria.new(self).find(obj)
      end

      def where(params)
        Oriental::Criteria.new(self).where(params)
      end

      def insert
        Oriental::Criteria.new(self).insert
      end

    end

  end
end
