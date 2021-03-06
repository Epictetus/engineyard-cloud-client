module EY
  class CloudClient
    class ResolverResult
      attr_reader :api, :matches, :errors, :suggestions

      def initialize(api, matches, errors, suggestions)
        @api, @matches, @errors, @suggestions = api, matches, errors, suggestions
      end

      def one_match?()    matches.size == 1 end
      def no_matches?()   matches.empty?    end
      def many_matches?() matches.size > 1  end

      def one_match(&block)    one_match?    && block && block.call(matches.first)       end
      def no_matches(&block)   no_matches?   && block && block.call(errors, suggestions) end
      def many_matches(&block) many_matches? && block && block.call(matches)             end
    end
  end
end
