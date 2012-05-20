# ./test/resque-mongo_benchmark.rb

#require 'rubygems'
#require 'resque-mongo'
require File.join(File.dirname(__FILE__), 'test_helper')
require 'benchmark'

class SimpleJob
  def self.perform
    "Awesome"
  end
end

class Job1 < SimpleJob
  @queue = :q1
end

class Job2 < SimpleJob
  @queue = :q2
end

class Job3 < SimpleJob
  @queue = :q3
end

class Job4 < SimpleJob
  @queue = :q4
end

class Array
  def rand
    self[Kernel.rand(length)]
  end
end

a = [0,1,2,3,4,5,6]

Resque.drop

result = Benchmark.measure do
  [Job1, Job2, Job3, Job4, Job3, Job2, Job1].each do |job|
    100.times do
      Resque.enqueue(job)
    end
  end
end

puts "Enqueuing"
puts result

worker = Resque::Worker.new("q1", "q2", "q3", "q4")
result = Benchmark.measure { worker.work(0) }

puts "Working"
puts result

# With 7 000 entries
#
# Enqueuing
#   1.250000   0.150000   1.400000 (  1.403977)
# Working
#  10.220000   1.020000  11.240000 ( 80.512621)
