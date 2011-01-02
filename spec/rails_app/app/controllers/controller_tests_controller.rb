class ControllerTestsController < ApplicationController

  # ab_test specs.
  def array
    render :text => ab_test('array_test', [1, 2, 3]).to_s
  end

  def array_bingo
    bingo! 'array_test'
    render :nothing => true
  end

  def boolean
    render :text => ab_test('boolean_test').to_s
  end

  def boolean_bingo
    bingo! 'boolean_test'
    render :nothing => true
  end

  def hash
    render :text => ab_test('hash_test', {1 => 2, 2 => 1}).to_s
  end

  def hash_bingo
    bingo! 'hash_test'
    render :nothing => true
  end

  def integer
    render :text => ab_test('integer_test', 3).to_s
  end

  def integer_bingo
    bingo! 'integer_test'
    render :nothing => true
  end

  def range
    render :text => ab_test('range_test', (1..3)).to_s
  end

  def range_bingo
    bingo! 'range_test'
    render :nothing => true
  end


  # ab_choose specs.
  def array_choose
    render :text => ab_choose('array_test', [1, 2, 3]).to_s
  end


  # specs for the helpers' behaviors with blocks
  def array_test_block
    ab_test 'array_test', [1, 2, 3] do |result|
      render :text => result.to_s
    end
  end

  def array_choose_block
    ab_choose 'array_test', [1, 2, 3] do |result|
      render :text => result.to_s
    end
  end


  # specs for an explicit conversion name
  def conversion
    number  = ab_test 'test_1', [1, 2, 3], :conversion => 'common_conversion'
    boolean = ab_test 'test_2',            :conversion => 'common_conversion'
    other_1 = ab_test 'other_1', (10..20), :conversion => 'other_conversion'
    other_2 = ab_test 'other_2', (30..40)

    render :text => [number, boolean, other_1, other_2].join('-')
  end

  def conversion_bingo
    bingo! 'common_conversion'
    render :nothing => true
  end
end
