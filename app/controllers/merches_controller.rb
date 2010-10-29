class MerchesController < ApplicationController

  def index
    @merches = Merch.all

  end


  def show
    @merch = Merch.find(params[:id])
	@orderable = @merch

  end


  def new
    @merch = Merch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merch }
    end
  end

  def edit
    @merch = Merch.find(params[:id])
  end


  def create
    @merch = Merch.new params[:merch]
	
    respond_to do |format|
      if @merch.save
		redirect_to(@merch, :notice => "Merch was successfully created.") 
      else
        render :action => "new" 
      end
    end
  end


  def update
    @merch = Merch.find params[:id]
	
    respond_to do |format|
      if @merch.update_attributes(params[:merch])
        format.html { redirect_to(@merch, :notice => 'Merch was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merch.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @merch = Merch.find(params[:id])
    @merch.destroy

    respond_to do |format|
      format.html { redirect_to(merches_url) }
      format.xml  { head :ok }
    end
  end


end
