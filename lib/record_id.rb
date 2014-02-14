module Oriental
  class RecordId
    attr_accessor :cluster, :position

    def initialize(rid=nil)
      @cluster = nil
      @position = nil
      parse_rid(rid)
    end

    def parse_rid(rid)
      match = rid.match(/#*(?<cluster>\d+):(?<position>\d+)/)
      @cluster = match[:cluster].to_i
      @position = match[:position].to_i
      self
    end

    def to_s
      "##{cluster}:#{position}"
    end

    def temporary?
      @cluster < 0
    end
  end

  class Rid < Virtus::Attribute
    def coerce(value)
      value.is_a?(::String) ? Oriental::RecordId.new(value) : value
    end
  end

  class Record
    include Oriental::Document
    attribute :rid, Oriental::Rid

    def initialize(record = {})
      self.extend(Virtus.model)
      record.each do |k, v|
        k = k.to_s[1..-1].to_sym if k.to_s[0] == "@"
        self.attribute k, v.class unless [:class].include? k
      end
      super(record)
    end
  end

end

