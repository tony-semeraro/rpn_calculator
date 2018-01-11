module RpnCalc
  module Interface
    # Please note, this is a bit more indirected and abstract then I'd normally do.
    # Depending on how the spec evolves this module might be replaceable by
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
end
