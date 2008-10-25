def fact(n)
  if n == 0
    1
  else
    n * fact(n-1)
  end
end

# From http://knanshon.blogspot.com/2006/08/ruby-permutations.html
class Array
  def each_permutation(&blockproc)
    a = []
    self.each do |c|
      a.push(c)
    end
    n = a.length
    p = Array.new(n+1,0)
    i = 1
    blockproc.call(a) 
    while i < n do
      if p[i] < i
        j = 0
        j = p[i] if (i % 2) == 1
        t = a[j]
        a[j] = a[i]
        a[i] = t
        p[i] = p[i] + 1
        i = 1
        blockproc.call(a) 
      else
        p[i] = 0
        i = i + 1
      end
    end
  end
end

choices = ARGV[0].to_i

if choices <= 7
  number_of_permutations = fact(choices)
  puts "There are #{number_of_permutations} permutations of #{choices}."
  puts
  set = (1..choices).to_a
  permutations = Array.new
  puts "They are:"
  puts
  set.each_permutation { |arr| permutations << arr.join }
  permutations.sort!

  # Display Data
  rows = number_of_permutations / choices
  row_set = Array.new
  rows.times { |c| row_set << Array.new }
  choices.times do |col|
    row_set.each do |r|
      r << permutations.shift
    end
  end

  row_set.each { |r| puts r.join("    ") }
else
  puts "Sorry, computing that many permutations will take too much processor power."
end
