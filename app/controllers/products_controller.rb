class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
	product = Product.new
	@cur = product.categoryById((params[:c]).to_i)
	@flag = 0 if @cur[:tab_name] == 'Все'
	@flag = 1 if @cur[:tab_name] != 'Все'
	if @flag != 0	
		@products = Product.find_all_by_visibility_and_category_id('visible', @cur[:id]) if user_type != 'admin'
		@products = Product.find_all_by_category_id(@cur[:id]) if user_type == 'admin'
	end
	@title = "Производимая продукция"
	@header = @title
	@meta_description = @title
	@robots_meta = [{:name => 'ROBOTS', :content => 'INDEX, FOLLOW'}]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
	@photos = @product.photos.all(:conditions => "id != #{@product.photo_id.to_s}") if @product.photo_id?
	@comments = @product.comments
	@component_types = @product.component_types
	@title = @product.s_name
	@header = @product.s_name
	@meta_description = @product.note
	@robots_meta = [{:name => 'ROBOTS', :content => 'INDEX, FOLLOW'}]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
	if user_type == 'admin'
		@product = Product.new
		@products = Product.all
		@attachment_file = AttachmentFile.new
		@action = 'create'
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @product }
		end
	else
		redirect_to products_path
	end
  end

  # GET /products/1/edit
  def edit
	@product = Product.find(params[:id])
	if user_type == 'admin'
		@products = Product.all
		@action = 'update'
		@attachment_file = AttachmentFile.new
		@device_photos = @product.photos(:order => 'id ASC')
	else
		redirect_to @product
	end
  end

  # POST /products
  # POST /products.json
  def create
	if user_type == 'admin'
		@product = Product.new(params[:product])
		respond_to do |format|
		  if @product.save
			if @product.photos != [] and @product.photos != nil and @product.photos != ""
				photo = Photo.find_by_product_id(@product.id)
				@product.update_attributes(:photo_id => photo.id)
			end
			format.html { redirect_to @product, :notice => 'Успешно обновлён' }
			format.json { render :json => @product, :status => :created, :location => @product }
		  else
			format.html { render :action => "new" }
			format.json { render :json => @product.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to products_path
	end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
	if user_type == 'admin'
		respond_to do |format|
		  if @product.update_attributes(params[:product])
			if @product.photo == nil
				photo = Photo.find_by_product_id(@product.id)
				@product.update_attributes(:photo_id => photo.id)
			end
			format.html { redirect_to @product, :notice => 'Успешно обновлено' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit" }
			format.json { render :json => @product.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to @product
	end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
	if user_type == 'admin'
		@product = Product.find(params[:id])
		@product.destroy
		respond_to do |format|
		  format.html { redirect_to products_url }
		  format.json { head :no_content }
		end
	else
		redirect_to products_path
	end
  end
end
