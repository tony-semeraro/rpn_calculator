require_relative "rpn_calc/interface"
require_relative "rpn_calc/main"

module RpnCalc
  class Calculator
    class Parser
      def self.tokenize_line(line)
        tokens = []
        return tokens unless line && line.length > 0
        line.chomp.split(' ').each do |lex|
          tokens << if Operator::WHITELIST.member?(lex)
                      Operator.new(lex)
                    else
                      Operand.new(lex)
                    end
        end
        tokens
      end
    end

    class Operator
      attr_reader :val
      WHITELIST = ['-', '+', '/', '*']
      def initialize(lex)
        @val = lex.to_sym
      end
    end

    class Operand
      attr_reader :val
      def initialize(val)
        @val = Float(val)
      end
    end

    class Evaluator
      # single stack evaluator
      # exceptions trickle up to main loop
      def self.perform(tokens, operand_stack)
        tokens.each do |token|
          if token.is_a?(Operand)
            operand_stack << token
          else
            right = operand_stack.pop
            left = operand_stack.pop
            if left.nil?
              # roll back the first pop and throw an error message
              operand_stack << right
              raise "stack too short, please add more values to perform: #{token.val}"
            end
            value = left.val.public_send(token.val, right.val)
            operand_stack << Operand.new(value)
          end
        end

        operand_stack
      end
    end
  end
end
