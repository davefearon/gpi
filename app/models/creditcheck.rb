class Creditcheck

  attr_accessor :cardnum
  attr_accessor :cardtype

  def checkcard()
      return false unless @cardnum && @cardnum.is_a?(String)
      return false if @cardnum.empty?

      @cardnum = @cardnum.gsub(/\D/, '')

      return false if @cardnum.empty?

      if @cardnum[0].chr.to_i == 4
        @cardtype = "visa"
      elsif @cardnum[0].chr.to_i == 5
        @cardtype = "mastercard"
      elsif @cardnum[0].chr.to_i == 3 && ( @cardnum[1].chr.to_i == 4 || @cardnum[1].chr.to_i == 7 )
        @cardtype = "amex"
      else
        @cardtype = "unknown"
      end
      
      @cardnum.
              reverse.
              each_char.
              collect(&:to_i).
              each_with_index.
              inject(0) {| num, (i, index) |
                num + if (index + 1) % 2 == 0
                  i*=2; ((i > 9) ? (i % 10) + 1 : i)
                else
                  i
                end
              } % 10 == 0
  end

end