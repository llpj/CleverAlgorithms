# Unit tests for grammatical_evolution.rb

# The Clever Algorithms Project: http://www.CleverAlgorithms.com
# (c) Copyright 2010 Jason Brownlee. Some Rights Reserved. 
# This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 2.5 Australia License.

require "test/unit"
#require Pathname.new(File.dirname(__FILE__)) + "../grammatical_evolution"
require "../grammatical_evolution"

class TC_GrammaticalEvolution < Test::Unit::TestCase
  
  # test that members of the population are selected
  def test_binary_tournament
    pop = Array.new(10) {|i| {:fitness=>i} }
    10.times {assert(pop.include?(binary_tournament(pop)))}  
  end
  
  # test point mutations at the limits
  def test_point_mutation
    assert_equal("0000000000", point_mutation("0000000000", 0))
    assert_equal("1111111111", point_mutation("1111111111", 0))
    assert_equal("1111111111", point_mutation("0000000000", 1))
    assert_equal("0000000000", point_mutation("1111111111", 1))
  end

  # test that the observed changes approximate the intended probability
  def test_point_mutation_ratio
    changes = 0
    100.times do
      s = point_mutation("0000000000", 0.5)
      changes += (10 - s.delete('1').size)
    end
    assert_in_delta(0.5, changes.to_f/(100*10), 0.05)
  end
  
  # test crossover
  def test_one_point_crossover
    # clone
    p = one_point_crossover({:bitstring=>"000000"}, {:bitstring=>"111111"}, 2, 0.0)
    assert_equal(6, p.size)
    assert_equal("000000", p)
    # TODO test a real crossover that respects codons
  end
  
  # test the duplication of a codon
  def test_codon_duplication
    # no change
    p = codon_duplication("000000", 2, 0.0)
    assert_equal(6, p.size)
    assert_equal("000000", p)
    # forced change
    p = codon_duplication("000000", 2, 1)
    assert_equal(8, p.size)
    assert_equal("00000000", p)
  end
  
  # test the deletion of a codon
  def test_codon_deletion
    # no change
    p = codon_deletion("000000", 2, 0)
    assert_equal(6, p.size)
    assert_equal("000000", p)
    # forced change
    p = codon_deletion("000000", 2, 1)
    assert_equal(4, p.size)
    assert_equal("0000", p)
  end
  
  def test_reproduce
    # TODO
  end
  
  # test the creation of random strings
  def test_random_bitstring
    assert_equal(10, random_bitstring(10).size)
    assert_equal(0, random_bitstring(10).delete('0').delete('1').size)
  end

  # test the approximate proportion of 1's and 0's
  def test_random_bitstring_ratio
    s = random_bitstring(1000)
    assert_in_delta(0.5, (s.delete('1').size/1000.0), 0.05)
    assert_in_delta(0.5, (s.delete('0').size/1000.0), 0.05)
  end
  
  # test the decoding of integers
  def test_decode_integers
    # single integer
    assert_equal(0, decode_integers("0000", 4)[0])
    assert_equal(1, decode_integers("1000", 4)[0])
    assert_equal(2, decode_integers("0100", 4)[0])
    assert_equal(3, decode_integers("1100", 4)[0])
    assert_equal(15, decode_integers("1111", 4)[0])
    # multiple integers
    p = decode_integers("11110100", 4)
    assert_equal(15, p[0])
    assert_equal(2, p[1])
  end
  
  def test_map
    # TODO
  end
  
  # test the target function
  def test_target_function
    assert_equal(0.0, target_function(0.0))
    assert_equal(3.0, target_function(1.0))
    assert_equal((2**3+2**2+2), target_function(2.0))
  end
  
  # test sampling from the domain
  def test_sample_from_bounds
    total, bounds = 200, [-1, +1]
    mean = 0.0
    total.times do
      x = sample_from_bounds(bounds)
      assert(x>=bounds[0], "x=#{x}")
      assert(x<=bounds[1], "x=#{x}")
      mean += x
    end
    assert_in_delta(mean/total.to_f, 0.0, 0.1)
  end
  
  # test the computation of cost for decoded programs
  def test_cost
    # bad program
    assert_equal(9999999, cost("INPUT", [-1, +1]))
    # optima
    optima = "(INPUT * (INPUT * INPUT)) + (INPUT * INPUT) + INPUT"
    assert_in_delta(0.0, cost(optima, [-1, +1]), 0.00000001)
    # a program that comes up a lot
    assert_in_delta(0.3, cost("INPUT  /  1.0", [-1, +1], 100), 0.1)
  end
  
  def test_evaluate
    # TODO
  end
  
  def test_search
    # TODO
  end
  
end