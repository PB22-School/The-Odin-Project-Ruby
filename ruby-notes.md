# Ruby Notes

### Things to watch out for:
- the number 0 does **NOT** boolean cast to false. Why?
- an empty string does **NOT** boolean cast to false.
- **the only thing that boolean casts to false is the value false and nil (Like None in python).**

Conversions usually use a case like:

```ruby
# keep in mind you have to have a decimal for floats:
num = 10 / 3.0

# num is a float
puts num      # => 3.33333...

puts num.to_i # =>  3
puts num.to_s # => "3"

# btw 'print' doesn't add a newline, while 'puts' does.
```

Ruby has a lot of built in helper functions that aren't at all necessary but make the code read a lot cleaner.

```ruby
num = 10 / 3

# num is an integer
puts num # => 3

# it's Ruby standard to put ?'s on functions that return booleans.
# from what I can tell the function 'even' doesn't exist but 'even?' does.
puts num.even? # => false
puts num.odd?  # => true
```

### Strings

Strings are weird in Ruby, you can use either single or double quote marks.

However, if you use single quotes, you can't use Interpolation (shown below) or escape characters (\n, \t, \r, etc.) So it seems like you should just use double quotes

Interpolation example:

```ruby
num = 10 / 3

puts "Your num is #{num}!" # => Your num is 3!
puts 'Your num is #{num}!' # => Your num is #{num}!
```

Built-in Helper methods:

```ruby
string = "hello world!"

# also negative indexing
string[-1]                  # => "!"

string.captialize           # => "Hello world!"

string.include?("world")    # => true

string.upcase               # => "HELLO WORLD!"

string.upcase.downcase      # => "hello world!"

string.empty?               # => false

string.length               # => 12

string.reverse              # => "!dlrow olleh"

string.split(" ")           # => ["hello", "world!"]

"    hello world!   ".strip # => "hello world!"

# seems to sub only the first occurence
string.sub("x", "l")        # => "hexlo world!"

# seems to sub every occurence
string.gsub("x", "l")       # => "hexxo worxd!"

string.insert(-1, " again!")# => "hello world! again!"

string.delete("l")          # => "heo word!"

# I hope no one ever uses this it's really weird
"hello".prepend(string, " hi! ") # => "hello world! hi! hello"

x.prepend(y, z) # => yzx
```

### Symbols
Hard-coded strings are different objects in memory. If you want your strings to be the same object (to use less memory,) use :symbols instead.

It seems to be the same as putting a "#define SYMBOL value" in C. But at the same time they seem weird to work with because you can't do addition or things like that. So maybe the only place they can really be used is in if statements?

```ruby
:thing1
:thing2

puts "Type a thing: "

# gets includes the \n, gets.chomp gets rid of it.
string = gets.chomp

if string == :thing1
    # do something

# not a huge fan of 'elsif'
elsif string == :thing2
    # do something else

else
    puts "that's not a thing."

end

```

Even this seems needlessly optimized, so I'm still not sure why this is needed. Once I figure it out I'll update this though.

### Memory Stuff

Trying to do lower-level tricks in Ruby is weird and it kind of makes my brain hurt.

```ruby
my_secret = "secret"

# shared_secret and my_secret point to the same place in memory
shared_secret = my_secret

shared_secret # => "secret"
my_secret     # => "secret"

# some operations give shared_secret it's own memory slot.

# for instance (for strings):
shared_secret += " new"

shared_secret # => "secret new"
my_secret     # => "secret"

# however, some operations do not give shared_secret it's own memory slot,
# and rather change the value already stored in the memory slot:
my_secret = "secret"
shared_secret = my_secret

# this operator concatenates a string. 
shared_secret << " pwned"

shared_secret # => "secret pwned"
my_secret     # => "secret pwned"

# which is a little weird, but kind of understandable.
# pretty much the concatination operator is 'in-place,' so it doesn't warrant a new memory slot.
# then, on the other hand, the += operator (behind the scenes) does this:
var = var + x

# it saves a different thing somewhere, which kind of makes sense.
```

Operations that change the memory are called 'unsafe,' and operations that don't change the memory are called 'safe.'

(so the '<<' operator is **unsafe**, while the '+=' operator is **safe**.)

It's standard Ruby to have unsafe functions have a '!' a the end.
```ruby
my_secret = "secret"
shared_secret = my_secret

# Safe Call:
shared_secret.upcase

shared_secret # => "SECRET"
my_secret     # => "secret"

shared_secret = my_secret

# Unsafe Call:
shared_secret.upcase!

shared_secret # => "SECRET"
my_secret     # => "SECRET"
```

### Variable Types

Global (entire-program scope) **not recommended for use**
```ruby
$global = "global var"
```

Class Variables and Class Instance Varaibles
```ruby
# the first letter of a class name MUST be capitalized.
class SomeClass
    # this variable is defined in memory, and every instance is given a pointer to it.
    @@how_many_are_there = 0

    # Ruby initialization function:
    def initialize(someVar)
        # this variable is local to the instance.
        @someVar = someVar
        @@how_many_are_there += 1
    end

    def how_many_are_there
        # ruby is one of those languages that returns the last operation:
        @@how_many_are_there
    end

end

ins_1 = SomeClass.new("ins_1")
ins_1.how_many_are_there # => 1

ins_2 = SomeClass.new("ins_2")
ins_2.how_many_are_there # => 2

ins_1.how_many_are_there # => 2

# one thing that's a bit aggravating is that you can't access instance variables (or global-class varaibles) outside of the instance scope.

# Error:
puts ins_1.someVar
```

Things happen right-first.

```ruby
2 * 3 / 3 # => 1
2 + 3 * 4 # => 14

# you can of course use parenthesis to fix this though.
# I do have to say though, it does make pretty good logical sense to do this.

(2 + 3) * 4 # => 20
```

### Miscellaneous Ruby Things
- ```x.eql?(y)``` checks for value and type equivalency. Like === in Javascript.
- ```x.equal?(y)``` checks if both values point to the same address in memory. Like &x == &y.
- Spaceship operator ```x <=> y``` 
    - does ```sign(y - x)```.
    - ```x < y``` ==> -1,
    - ```x = y``` ==> 0,
    - ```x > y``` ==> -1.
- and or &&, or or ||.
- logical operations always go left to right.
- logical operators also don't check values unless they have to.
- functions that end in ! are called bang methods!
- Nested arrays are canon[0][1].

### Cases, If & Unless

```ruby
x = 3

something = case x
    when 1 then "one"
    # OR
    when 2 
        "two" << ", which is greater than one."
    when 3 then "three"
    else "nothing"
end
```

```ruby
if true
    puts "always runs"
end

unless false
    puts "always runs"
end
```

```ruby

age = 21

response = age >= 21 ? "you can drink." : "you cannot drink."

puts response
```

### Loops

```ruby
while true do
    puts "infinite loop"
end

loop do
    puts "infinite loop"
end

until false do
    puts "infinite loop"
end

# inclusive range
my_range = (1..5)  # => 1, 2, 3, 4, 5

# non-inclusive range
my_range = (1...5) # => 1, 2, 3, 4

# You can also make ranges of characters.
# the .to_a converts it to an array.

my_range = ('a'..'z').to_a

for i in my_range
    puts "#{i}..."
end

5.times do
    puts "SAYS THIS 5 TIMES"
end

5.times do |num|
    puts "SAYS THIS 5 TIMES #{num}."
end

5.upto(10) do |num|
    puts num
end

# 5
# 6
# 7
# 8
# 9
# 10

# also x.downto(y) exists, also inclusive, pretty straight forward.
```

### Arrays

```ruby

# Arrays have some interesting ways to be created in Ruby:

Array.new()         # => []
Array.new(3)        # => [nil, nil, nil]
Array.new(3, 7)     # => [7, 7, 7]
Array.new(4, true)  # => [true, true, true, true]

# indexing works the same as with strings.

cool_array = ["this", "Array", "is", "cool"]
cool_array.first    # => ["this"]
cool_array.first(2) # => ["this", "Array"]

cool_array.push("as", "$@!$") # => ["this", "Array", "is", "cool", "as", "$@!$"]

# you can also use << instead of .push
cool_array << "as $@!$"

# returns last index
cool_array.pop # => "as $@!$"

# unshift adds something to the front, shift gets rid of it
cool_array.unshift("not") # => ["not", "this", "Array", "is", "cool", "as", "$@!$"]

cool_array.shift # => ["this", "Array", "is", "cool", "as", "$@!$"]

# shift and pop have an optional param, how many you want to pop / shift.

a = [1]
b = [2]

a + b       # => [1, 2]
a.concat(b) # => [1, 2]

# Subtract Arrays???

[1, 1, 1, 2, 2, 3, 4] - [1, 4]  #=> [2, 2, 3]

# extras:
# empty?, reverse, length, include?(x), join, join(x).

# If you want to access an array index you aren't sure exists, use dig.

a.dig(2) # => nil, but no error!
```

### Dictionaries (Hashes)

```ruby
# you can make a dictionary (called a hash in Ruby) like this:

my_dictionary = {
    "hello" => 2,
    "world" => 1
}

my_dictionary["hello"] # => 2

# returns value of my_dictionary["!"] or default
my_dictionary.fetch("!", "default") 

my_dictionary.delete("world")

# Works almost exactly like python, .keys, .values.

# you can merge two dictionaries with .merge

# you can define dictionaries with symbols like this:
:hello
:world

my_dict = {
    hello: 2,
    world: 1
}

# then do this:

# which could be the use-case for symbols??
my_dict[:hello]
```

### Functions

```ruby

# copied this from the Odin Project

# Valid and Invalid method names:
method_name      # valid
_name_of_method  # valid
1_method_name    # invalid
method_27        # valid
method?_name     # invalid
method_name!     # valid
begin            # invalid (Ruby reserved word)
begin_count      # valid

# define function (with optional param) like this:
def function_w_optional_param(param = "optional")
    puts param
    # last thing is returned (puts returns nil, so it returns nil)
    # you can also use the 'return' keyword but it's excess.
end

# the built-in function's standards let you auto-write to memory or not auto-write to memory

# it's the same syntax as safe / unsafe functions as before:

# unsafe functions (ending in !) auto-write
# safe functions (not ending in !) don't auto-write
```

### Debugging

The Odin Project says to use [Pry-byebug](https://github.com/deivid-rodriguez/pry-byebug) to debug.

```ruby
require 'pry-byebug'

a = 4
b = 6

# This line stops execution and opens an irb-like enviornment where you can see the values of variables
binding.pry
```

I haven't tried it yet but it sounds like a good way to debug.

### Enumerables

These are like the array generators in python:

```ruby
friends = ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']

# all of these are in-place, I jsut don't want to have to keep writing the friends = [] line.

# adds to list when condition met.
# .select == .filter
friends.select { |friend| friend != 'Brian' }
 #=> ["Sharon", "Leo", "Leila", "Arun"]

# adds to list when condition not met.
friends.reject { |friend| friend == 'Brian' }
 #=> ["Sharon", "Leo", "Leila", "Arun"]

# loops for everything in list.
# this one doesn't do it in-place, in fact it always returns the original data.
friends.each { |friend| puts "Hello, " + friend }

# you can run all of these on arrays or dictionaries. For dictionaries you can either do |pair| or |key, value|.

friends.each_with_index { |friend, i| puts "Hello #{i}th friend,  " + friend }

# if you want each to save the changes, you can use map instead.
# .map == .collect
friends.map { |friend| "Hello, " + friend }

# .reduce == .inject
# reduce reduces an array or dictionary to a single value.
sum_this_please = [1, 50, 123, 101]

# the first value is the accumulator, and the second is the iteration variable. 
sum_this_please.reduce { |sum, ith| sum + ith }
# => 275

# reduce takes an optional param, auto-setting the accumulator:
sum_this_please.reduce(25) { |sum, ith| sum + ith }
# => 300

```

```ruby

# Boolean Enumerables 🤖

nums = [100, 20, 30, 50]

# is this true for any??
nums.any? { |num| num > 101 }

# is this true for all?
nums.all? { ... }

# is this true for none??
# none = !any
nums.none? { ... }
```

