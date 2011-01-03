class User
  include Mingo::Helpers

  def initialize(id)
    @id = id
  end

  def test
    ab_test 'user', (1..50)
  end

  def bingo
    bingo! 'user'
  end

  private

  def mingo_id
    @id + '-san'
  end
end
