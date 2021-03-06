
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
  attr_accessor :name, :hope
  def initialize(data)
    @name, rank = data.split(':')
    @hope = rank.split(',')
  end

  def male?
    @is_male ||= @name =~ /[A-Z]/
  end
end

class Couple
  attr_accessor :male, :female
  def initialize(m, f)
    @male = m
    @female = f
  end

  def point
    if @male.hope.include?(@female.name) and @female.hope.include?(@male.name)
      @point ||= @male.hope.index(@female.name) + @female.hope.index(@male.name)
    else
      nil
    end
  end
  
  def str
    "#{@male.name}-#{@female.name}"
  end

  def str_debug
    "#{@male.name}-#{@female.name}:#{point}"
  end

  def <=>(another)
    if self.point.nil?
      -1
    elsif another.point.nil?
      1
    else
      self.point <=> another.point
    end
  end
end

class Calc 
  def self.parse(input_data)
    input_data.split("\n").map(&Person.method(:new))
  end

  def self.generate_couple(people)
    people
    .combination(2)
    .select {|one, another|
      one.male? != another.male?
    }
    .map {|one, another|
      Couple.new(one, another)
    }
  end

  def self.pick(member_real)
    member = member_real
    proc {|sorted|
      sorted.each_with_object([]) {|couple, acc|
        if member.include?(couple.male.name) and member.include?(couple.female.name)
          acc << couple
          member = (member - [couple.male.name, couple.female.name])
        end
      }
    }
  end
end

people = Calc.parse(inp)
picker = Calc.pick(people.map(&:name))
couples = Calc.generate_couple(people)
sorted = couples.sort

ans = picker.(sorted).sort_by {|v| v.male.name }
ans.each {|c|
  puts c.str
}
