class ControllerTestsController < ApplicationController
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
end
