
def fib(n)

  if n == 0
    return 0
  elsif n == 1
    return 1
  end

  return fib(n - 1) + fib(n - 2)
end
  
puts fib(8)
  