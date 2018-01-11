require_relative "test_helper"

class RpnCalcTest < Minitest::Test
  def test_from_wikipedia_page
    # https://en.wikipedia.org/wiki/Reverse_Polish_notation
    # has an example where the string of input evaluates to 5
    operand_stack = []
    line = '15 7 1 1 + - / 3 * 2 1 1 + + -'
    tokens = RpnCalc::Calculator::Parser.tokenize_line(line)
    RpnCalc::Calculator::Evaluator.perform(tokens, operand_stack)
    assert operand_stack.size == 1
    assert operand_stack.pop.val == 5.0
  end

  def test_empty_input
    operand_stack = []
    line = ''
    tokens = RpnCalc::Calculator::Parser.tokenize_line(line)
    RpnCalc::Calculator::Evaluator.perform(tokens, operand_stack)
    assert operand_stack.size == 0
  end

  def test_illegal_input
    operand_stack = []
    line = '-'
    tokens = RpnCalc::Calculator::Parser.tokenize_line(line)
    assert_raises RuntimeError do
      RpnCalc::Calculator::Evaluator.perform(tokens, operand_stack)
    end
  end
end
