class Imaker

  attr_accessor :query
  attr_accessor :image
  attr_accessor :width
  attr_accessor :height
  attr_accessor :format
  attr_accessor :background
  attr_accessor :bg_r
  attr_accessor :bg_g
  attr_accessor :bg_b
  attr_accessor :bgcolor
  attr_accessor :text
  attr_accessor :txt_r
  attr_accessor :txt_g
  attr_accessor :txt_b
  attr_accessor :txtcolor
  attr_accessor :textsize
  attr_accessor :string
  attr_accessor :message
  attr_accessor :matches
  attr_accessor :count
  attr_accessor :i
  attr_accessor :sizeloc
  attr_accessor :header

  def initialize(*)
    @format = ".gif"
    @textsize = 12
    @message
    @count = 0
    @i = 0
  end

  def input( q )
    @query = q
    self.split_params
    self.set_params
    return true
  end

  def split_params
    @matches = @query.split(/\//)
    @count = @matches.length
    return true
  end

  def set_params
    i = 0
    @matches.each do |m|
      if !m.match(/([0-9]){1,4}([x])([0-9]){1,4}/).nil?
        @sizeloc = i
      else
        i += 1
      end
    end

    puts @sizeloc

    if @sizeloc == 0
      # no need to do anything
      @background = ""
      @text = ""
    elsif @sizeloc == 1
      @background = @matches[0]
      @text = ""
    elsif @sizeloc == 2
      @background = @matches[0]
      @text = @matches[1]
    end

    puts @background
    puts @text

    self.set_widthheight
    self.set_bgcolors
    self.set_txtcolors
    self.set_format
    self.set_message

    return true
  end

  def set_widthheight
    @width = @matches[@sizeloc].match(/[0-9]+/)[0]
    @height = @matches[@sizeloc].match(/x([0-9]+)/).to_a[1]
    return true
  end

  def set_bgcolors
    r = "c8"
    g = "c8"
    b = "c8"

    if @background.length > 1
      if @background.match(/[0-9a-fA-F]{3,6}/)
        if @background.length == 6
          r = @background[0,2]
          g = @background[3,2]
          b = @background[5,2]
          @background = "#" + @background
        elsif @background.length == 3
          r = @background[0,1] + @background[0,1]
          g = @background[1,1] + @background[1,1]
          b = @background[2,1] + @background[2,1]
          @background = "#" + @background
        else
          r = "c8"
          g = "c8"
          b = "c8"
        end
        @bg_r = r.hex
        @bg_g = g.hex
        @bg_b = b.hex
      else
        arr = self.convert_to_rgb( @background, true )
        @bg_r = arr[0]
        @bg_g = arr[1]
        @bg_b = arr[2]
      end
    else
      @background = "#c8c8c8"
      @bg_r = 200
      @bg_g = 200
      @bg_b = 200
    end
    
    return true
  end

  def set_txtcolors
    r = "ff"
    g = "ff"
    b = "ff"
    
    if @text.length > 1
      if @text.match(/[0-9a-fA-F]{3,6}/)
        if @text.length == 6
          r = @text[0,2]
          g = @text[3,2]
          b = @text[5,2]
          @text = "#" + @text
        elsif @text.length == 3
          r = @text[0,1] + @text[0,1]
          g = @text[1,1] + @text[1,1]
          b = @text[2,1] + @text[2,1]
          @text = "#" + @text
        else
          r = "ff"
          g = "ff"
          b = "ff"
        end
        @txt_r = r.hex
        @txt_g = g.hex
        @txt_b = b.hex
      else
        arr = self.convert_to_rgb( @text, true )
        @txt_r = arr[0]
        @txt_g = arr[1]
        @txt_b = arr[2]
      end
    else
      @text = "#ffffff"
      @txt_r = 255
      @txt_g = 255
      @txt_b = 255
    end

    return true
  end

  def convert_to_rgb(color, isbg = true)
    r = 200
    g = 200
    b = 200

    case color
      when "red"
        r = 255
        g = 0
        b = 0
      when "black"
        r = 0
        g = 0
        b = 0
      when "white"
        r = 255
        g = 255
        b = 255
      when "yellow"
        r = 255
        g = 0
        b = 255
      when "green"
        r = 0
        g = 255
        b = 0
      when "blue"
        r = 0
        g = 0
        b = 255
      when "cyan"
        r = 0
        g = 255
        b = 255
      when "magenta"
        r = 255
        g = 255
        b = 0
      else
        if !isbg
          r = 255
          g = 255
          b = 255
        else
          r = 200
          g = 200
          b = 200
        end
    end
    
    return [r, g, b]
  end

  def set_format
    f = @matches[@sizeloc].match(/([\.])([a-zA-Z])+/)
    if !f.nil?
      @format = f[0]
    end

    return true
  end

  def set_message
    if @sizeloc + 1 < @count
      j = @sizeloc + 2
      for i in j..@count do
        if i == @sizeloc + 1
          @message = @matches[@sizeloc + 1]
        else
          if @message.nil?
            @message = ( @matches[i-1] )
          else
            @message += ( "\n" + @matches[i-1] )
          end
        end
      end
    end

    if @message == "" || @message.nil?
      @message = @width + " x " + @height
    else
      @message = @message.gsub( /[_]+/, " ")
    end

    return true
  end
  
  def create
    theimage = Magick::Image.new(@width.to_i,@height.to_i, Magick::HatchFill.new(@background,@background))
    gc = Magick::Draw.new
    # gc.line(0,0,@width.to_i,@height.to_i)
    # gc.line(@width.to_i,0,0,@height.to_i)
    # gc.line(-1,-1,-1,-1)

    gc.font_family = 'helvetica'
    gc.pointsize = @textsize
    gc.gravity = Magick::CenterGravity

    c = @text

    gc.annotate(theimage, 0,0,0,0, @message) {
      self.fill = Magick::Pixel.from_color(c)
    }

    # gc.draw(theimage)
    # theimage.write('public/images/default' + @format)

    case @format
      when ".gif"
        theimage.format = "GIF"
      when ".jpg"
        theimage.format = "JPEG"
      when ".jpeg"
        theimage.format = "JPEG"
      when ".png"
        theimage.format = "PNG"
      else
    end

    theimage = theimage.to_blob
    @image = theimage
    return @image
  end
  
  def content_type
    case @format
      when ".gif"
        contenttype = "image/gif"
      when ".jpg"
        contenttype = "image/jpeg"
      when ".jpeg"
        contenttype = "image/jpeg"
      when ".png"
        contenttype = "image/png"
      else
        contenttype = "image/gif"
    end

    return contenttype
  end
end