class ControllerTestsController < ApplicationController

  # ab_test specs.
  def array
    render :text => ab_test('array_test', [1, 2, 3]).to_s
  end

  def array_bingo
    bingo! 'array_test'
    render :text => 'nil'
  end

  def boolean
    render :text => ab_test('boolean_test').to_s
  end

  def boolean_bingo
    bingo! 'boolean_test'
    render :text => 'nil'
  end

  def range
    render :text => ab_test('range_test', (1..3)).to_s
  end

  def range_bingo
    bingo! 'range_test'
    render :text => 'nil'
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
end
