module Oriental
  module Document

    def self.included(base)
        base.include(Virtus.model)
        base.extend(ClassMethods)
        base.include(Veto.validator)
        base.include(InstanceMethods)
        base.include(Oriental::Attributes::Base)
    end

    module InstanceMethods
      def initialize(record = {})
        unless record.empty?
          if Oriental::RecordId.new(record[:@rid]).cluster < 0
            record.delete(:@rid)
          end
          record[:properties] = record.clone
          map = record.map do |k, v|
            k = k.to_s[1..-1].to_sym if k.to_s[0] == "@"
            k = :klass if k == :class
            v = Oriental::RecordId.new(v) if k == :rid
            [k, v]
          end
          record = Hash[map]
        end
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

      def select(*fields)
        Oriental::Criteria.new(self).select(fields)
      end

      def returns_anything?
        false
      end

    end

  end
end
