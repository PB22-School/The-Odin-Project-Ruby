
def is_sorted?(array, least_to_greatest = true)
  0.upto(array.length - 2) do |i|
    if (least_to_greatest ? array[i]: -array[i]) > (least_to_greatest ? array[i + 1]: -array[i + 1])
      return false
    end
  end

  true
end

def bubble_sort(array, least_to_greatest = true)
  
  loop do
    0.upto(array.length - 2) do |i|
      if (least_to_greatest ? array[i]: -array[i]) > (least_to_greatest ? array[i + 1]: -array[i + 1])
        temp = array[i + 1]
        array[i + 1] = array[i]
        array[i] = temp
      end
    end

    if is_sorted?(array, least_to_greatest)
      break
    end

  end

  array

end

puts bubble_sort([4,3,78,2,0,2], false)