require_relative "rpn_calc/version"

module RpnCalc
  module Interface
    # Please note, this is a bit more indirected and abstract then I'd normally do.
    # Depending on how the spec evolves this module might be replacable by
    # simply re-assigning $stdin in the setup code for the main loop
    # and just using gets without a wrapper.
    class Readline
      EOS_DELIMITER = ["\n"]
      RESET = /^(c|r|clear|reset)$/i

      def self.reader
        -> { gets }
      end

      def self.writer
        -> (write_out) { puts write_out }
      end
    end
  end

  class Main
    def self.run(interface = RpnCalc::Interface::Readline)
      reader = interface.reader
      writer = interface.writer
      operand_stack = []
      loop do
        line = reader.call
        break unless line
        break if interface::EOS_DELIMITER.any? { |delim| line == delim }
        if line =~ interface::RESET
          operand_stack = []
          line = ''
          writer.call 'clear'
        end
        begin
          tokens = Calculator::Parser.tokenize_line(line)
          Calculator::Evaluator.perform(tokens, operand_stack)
          if operand_stack.size > 1
            # stack is still loaded with values - display them and continue to operate on them
            writer.call 'stack: ' + operand_stack.map { |o| o.val }.join(', ')
          else
            writer.call operand_stack.first&.val
          end
        rescue => e # gotta catch 'em all
          writer.call e.message
        end
      end
    end
  end
  class Calculator
    class Parser
      def self.tokenize_line(line)
        tokens = []
        return tokens unless line && line.length > 0
        line.chomp.split(' ').each do |lex|
          tokens <<   if Operator::WHITELIST.member?(lex)
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
