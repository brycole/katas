# kata09
# bryan cole
# 1.5.2020

require 'test-unit'

pricing_rules = {}
pricing_rules[:A] = [50, 3, 130]
pricing_rules[:B] = [30, 2, 45]
pricing_rules[:C] = [20]
pricing_rules[:D] = [15]
RULES = pricing_rules # constant to work with test spec

class CheckOut
  def initialize(pricing_rules)
    @rules = pricing_rules
    @log = {}
  end

  def scan(item)
    # scan all items into log
    item = item.to_sym
    @log[item] = @log[item].nil? ? 1 : @log[item] + 1
  end

  def total
    total = 0
    @log.each do |item, quantity|
      if @rules[item].size > 1 # determine if special pricing
        total += quantity / @rules[item][1] * @rules[item][2]
        total += quantity % @rules[item][1] * @rules[item][0]
      else
        total += @rules[item][0] * quantity
      end
    end
    total
  end
end

# testing without Test::Unit
# co = CheckOut.new(pricing_rules)
# co.scan("A")
# co.scan("B")
# co.scan("A")
# price = co.total

class TestPrice < Test::Unit::TestCase

  def price(goods)
    co = CheckOut.new(RULES)
    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  def test_totals
    assert_equal(  0, price(""))
    assert_equal( 50, price("A"))
    assert_equal( 80, price("AB"))
    assert_equal(115, price("CDBA"))

    assert_equal(100, price("AA"))
    assert_equal(130, price("AAA"))
    assert_equal(180, price("AAAA"))
    assert_equal(230, price("AAAAA"))
    assert_equal(260, price("AAAAAA"))

    assert_equal(160, price("AAAB"))
    assert_equal(175, price("AAABB"))
    assert_equal(190, price("AAABBD"))
    assert_equal(190, price("DABABA"))
  end

  def test_incremental
    co = CheckOut.new(RULES)
    assert_equal(  0, co.total)
    co.scan("A");  assert_equal( 50, co.total)
    co.scan("B");  assert_equal( 80, co.total)
    co.scan("A");  assert_equal(130, co.total)
    co.scan("A");  assert_equal(160, co.total)
    co.scan("B");  assert_equal(175, co.total)
  end
end
