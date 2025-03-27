
def stock_picker(prices)

  buy_index = 0
  sell_index = 0

  0.upto(prices.length - 1) do |i|

    i.upto(prices.length - 1) do |j|
      if prices[j] - prices[i] > prices[sell_index] - prices[buy_index]
        sell_index = j
        buy_index = i
      end
    end
  end

  [buy_index, sell_index]

end

puts stock_picker([17,3,6,9,15,8,6,1,10])