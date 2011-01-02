class ControllerTestsController < ApplicationController

  # ab_test specs.
  def array
    render :text => ab_test('array', [1, 2, 3]).to_s
  end

  def array_bingo
    bingo! 'array'
    render :nothing => true
  end

  def boolean
    render :text => ab_test('boolean').to_s
  end

  def boolean_bingo
    bingo! 'boolean'
    render :nothing => true
  end

  def hash
    render :text => ab_test('hash', {1 => 2, 2 => 1}).to_s
  end

  def hash_bingo
    bingo! 'hash'
    render :nothing => true
  end

  def integer
    render :text => ab_test('integer', 3).to_s
  end

  def integer_bingo
    bingo! 'integer'
    render :nothing => true
  end

  def range
    render :text => ab_test('range', (1..3)).to_s
  end

  def range_bingo
    bingo! 'range'
    render :nothing => true
  end


  # ab_choose specs.
  def array_choose
    render :text => ab_choose('array', [1, 2, 3]).to_s
  end


  # specs for the helpers' behaviors with blocks
  def array_test_block
    ab_test 'array', [1, 2, 3] do |result|
      render :text => result.to_s
    end
  end

  def array_choose_block
    ab_choose 'array', [1, 2, 3] do |result|
      render :text => result.to_s
    end
  end


  # specs for multiple conversions
  def multiple_conversion
    number  = ab_test 'test_1', [1, 2, 3]
    boolean = ab_test 'test_2'
    other_1 = ab_test 'other_1', (10..20)
    other_2 = ab_test 'other_2', (30..40)

    render :text => [number, boolean, other_1, other_2].join('-')
  end

  def multiple_conversion_bingo
    bingo! 'test_1', 'test_2'
    render :nothing => true
  end
end
