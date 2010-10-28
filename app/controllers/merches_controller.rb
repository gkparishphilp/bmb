class MerchesController < ApplicationController
  # GET /merches
  # GET /merches.xml
  def index
    @merches = Merch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merches }
    end
  end

  # GET /merches/1
  # GET /merches/1.xml
  def show
    @merch = Merch.find(params[:id])
	@orderable = @merch

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merch }
    end
  end

  # GET /merches/new
  # GET /merches/new.xml
  def new
    @merch = Merch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merch }
    end
  end

  # GET /merches/1/edit
  def edit
    @merch = Merch.find(params[:id])
  end

  # POST /merches
  # POST /merches.xml
  def create
    @merch = Merch.new(params[:merch])
	@merch.price = price_in_cents(params[:merch][:price])
	
    respond_to do |format|
      if @merch.save
        format.html { redirect_to(@merch, :notice => "Merch was successfully created.") }
        format.xml  { render :xml => @merch, :status => :created, :location => @merch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merches/1
  # PUT /merches/1.xml
  def update
    @merch = Merch.find(params[:id])
	params[:merch][:price] = price_in_cents(params[:merch][:price])
	
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

  # DELETE /merches/1
  # DELETE /merches/1.xml
  def destroy
    @merch = Merch.find(params[:id])
    @merch.destroy

    respond_to do |format|
      format.html { redirect_to(merches_url) }
      format.xml  { head :ok }
    end
  end


end
