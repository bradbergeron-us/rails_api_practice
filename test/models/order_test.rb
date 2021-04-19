require "test_helper"

class OrderTest < ActiveSupport::TestCase

  setup do
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test 'Should have a positive total' do
    order = orders(:one)
    order.total = -1
    assert_not order.valid?
  end
end
