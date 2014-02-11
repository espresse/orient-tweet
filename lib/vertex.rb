module Oriental
  module Graph
    module Vertex
      def self.included(base)
        base.include(Virtus.model)
        base.include(Veto.validator)
        base.extend(Oriental::Document::ClassMethods)
        base.include(Oriental::Document::InstanceMethods)
      end
    end
  end
end