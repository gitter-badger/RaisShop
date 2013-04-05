require 'zeus/parallel_tests'

class CustomPlan < Zeus::ParallelTests::Rails
end

Zeus.plan = CustomPlan.new
