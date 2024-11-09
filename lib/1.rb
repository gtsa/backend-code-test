class FizzBuzz
  attr_reader :fizz, :buzz

  def initialize(fizz, buzz)
    @fizz = fizz
    @buzz = buzz
  end


  def lets_play
    (1..50).each do |i|
      if i % (@fizz * @buzz) == 0
        puts 'FizzBuzz'
      elsif i % @fizz == 0
        puts 'Fizz'
      elsif i % @buzz == 0
        puts 'Buzz'
      else
        puts i
      end
    end
  end
end

puts "Give me number for Fizz:"
fizz = gets.chomp.to_i
puts "Give me number for Buzz:"
buzz = gets.chomp.to_i

test = FizzBuzz.new(fizz, buzz)
test.lets_play
