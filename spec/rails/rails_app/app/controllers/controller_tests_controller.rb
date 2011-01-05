class ControllerTestsController < ApplicationController


  # ab_test specs.

  def array
    render :text => ab_test('array', [1, 2, 3])
  end

  def array_block
    ab_test 'array', [1, 2, 3] do |result|
      render :text => result
    end
  end

  def array_bingo
    bingo! 'array'
    render :nothing => true
  end


  # ab_test alternatives specs.

  def boolean
    render :text => ab_test('boolean')
  end

  def hash
    render :text => ab_test('hash', {1 => 2, 2 => 1})
  end

  def integer
    render :text => ab_test('integer', 3)
  end

  def range
    render :text => ab_test('range', (1..3))
  end


  # ab_choose specs.

  def array_choose
    render :text => ab_choose('array', [1, 2, 3])
  end

  def array_block_choose
    ab_choose 'array', [1, 2, 3] do |result|
      render :text => result
    end
  end


  # specs for multiple bingos

  def multiple_bingo
    bingo! 'array', 'boolean'
    render :nothing => true
  end

end
