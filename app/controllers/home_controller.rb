class HomeController < ApplicationController
  def index
    flash[:notice] = params[:q]
    
      respond_to do |format|
        format.html # index.html.erb
      end
  end

  def set_layout
    session["layout"] = (params[:mobile] == 0) ? "application" : ""
    redirect_to :action => "index"
  end

  def image
    @img = Imaker.new()
    @img.input(params[:path])
    theimage = @img.create()
    
    render :text => theimage, :status => 200, :content_type => @img.content_type()
  end

end
