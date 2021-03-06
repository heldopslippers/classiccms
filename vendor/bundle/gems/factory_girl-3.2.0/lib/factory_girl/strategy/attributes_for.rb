module FactoryGirl
  module Strategy
    class AttributesFor
      def association(runner)
        runner.run(Strategy::Null)
      end

      def result(evaluation)
        evaluation.hash
      end
    end
  end
end
