def mingo_tester(&block)
  klass = Class.new do
    include Mingo::Helpers

    attr_accessor :id

    def initialize(id = nil)
      @id = id || randomize_id!
    end

    def choose
      ab_choose :test
    end

    def test
      ab_test :test
    end

    def bingo
      bingo! :test
    end

    def mingo_id
      @id
    end

    def randomize_id!
      @id = -rand(2**31)
    end
  end

  klass.class_eval(&block) if block_given?
  klass
end
