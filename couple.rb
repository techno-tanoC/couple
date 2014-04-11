
inp = <<INP
A:c,b,a
B:a,b,d
C:a,c,b
D:d,a,c
a:A,C,D
b:D,A,B
c:B,A,C
d:D,C,A
INP

class Person
  attr_accessor :name, :hope, :ismale
  def initialize(data)
    @name, rank = data.split(':')
    @hope = rank.split(',')
    @ismale= @name =~ /[A-Z]/ ? true : false
  end
end

class Couple
  attr_accessor :point, :male, :female
  def initialize(m, f)
    @point = calc(m, f)
    @male = m
    @female = f
  end

  def calc(male, female)
    point =(male.hope.include?(female.name) ? male.hope.index(female.name) : 99) +(female.hope.include?(male.name) ? female.hope.index(male.name) : 99)
  end

  def str()
    "#{@male.name}-#{@female.name}:#{@point}"
  end
end

module Calc 
  def parse(input_data)
    input_data.split("\n").map(&Person.method(:new))
  end

  def generate_couple(people)
    people
    .combination(2)
    .select {|pair|
      pair[0].ismale != pair[1].ismale
    }
    .map {|pair|
      Couple.new(pair[0], pair[1])
    }
  end

  def pick(member)
    proc {|sorted|
      match = []
      sorted.each {|couple|
        if member.include?(couple.male.name) and member.include?(couple.female.name)
          match << couple
          member = (member - [couple.male.name, couple.female.name])
        end
      }
      match 
    }
  end

  module_function :parse, :generate_couple, :pick
end

people = Calc.parse(inp)
picker = Calc.pick(people.map {|p| p.name})
couples = Calc.generate_couple(people)
sorted = couples.sort {|a, b| a.point <=> b.point }

ans = picker.(sorted)
ans.each {|c|
  puts c.str
}