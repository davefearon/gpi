class ShopifyController < ApplicationController
  def index
  end

  def isAnagramOfPalindrome ( s )
    count = 0
    s.downcase!
    a = s.split('').sort
    b = Hash.new(0)

    a.each do |chr|
      b[chr] += 1
    end

    b.each do |v|
      if v[1] % 2 == 1
        count += 1
      end
    end

    return 1 if count <= 1

    return 0
    #      # make sure the string is in lowercase
#      s.downcase!
#      # save for reference
#      # originalstring = s
#      # take the string and convert to array
#      array1 = s.split('').sort
#      # take the array and iterate over each element and compare it with the next element
#      num = 0
#      count = 0
#      s.each do |i|
#        if array1[num] != array1[num + 1]
#          num += 2
#        else
#          count += 1
#        end
#      end
#
#    if count < 2
#      return 1
#    end
#
#    return 0
  end

  def countComplementaries (k, arr)
    i = 0
    j = arr.length - 1
    count = 0

    while i <= j
      if arr[i] + arr[j] == k
        count += 1

        if i != j
          count += 1
        end
        i += 1
        j -= 1
      elsif arr[i] + arr[k] < k
        i += 1
      else
        j -= 1
      end
    end
    return count
  end

  def credit

    # @cardtype = isAnagramOfPalindrome( "aaabcbc" )
    @cardtype = symmetryPoint("racecar")
    flash[:notice] = @cardtype

    # valid = Creditcheck.new

    # valid.cardnum = "4551-2100-4813-5230"

    # @isvalid = valid.checkcard

    # @cardtype = valid.cardtype
  end

  def symmetryPoint ( s )
    s.downcase!

    if s.length % 2 == 1
      i = s.length - 1

      if s[0,i/2] == s[(i/2)+1,i/2].reverse
        puts "double same"
        return i / 2
      end
      return -1
    end

    return -1
  end

  def nesting ( s )
    count = 0
    str = s.split('')
    str.each do |c|
      if c.to_s == "("
        count += 1
      elsif c.to_s == ")"
        count -= 1
      end
    end
    return 1 if count == 0
    return 0
  end


  def reg
    places = ["Training in ottawa and elsewhere",
              "i am at A1B 2C3 for an imaginery place",
              "my parents are at K4P 1P8"]

    places.each do |place|
      if place =~ /\b([A-Z]{1,2}\d\w?)\s+\d[A-Z]{2}\b/
        puts %Q!We found #{$&} sorted via #{$1}!
      end
    end

  end
end
