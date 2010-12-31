# Helper to run a set of specs several times under different conditions.
def branch(*args, &block)
  args.map { |sym| ActiveSupport::StringInquirer.new sym.to_s }.each(&block)
end
