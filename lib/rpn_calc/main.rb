module RpnCalc
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
end
