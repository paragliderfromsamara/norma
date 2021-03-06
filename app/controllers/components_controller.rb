class ComponentsController < ApplicationController
  # GET /components
  # GET /components.json
  def index
	@title = @header = 'Комплектующие'
	@component_types = ComponentType.order('name ASC')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @components }
    end
  end

  # GET /components/1
  # GET /components/1.json
  def show
    @component = Component.find(params[:id])
	@title = @header = @component.name
	@componentLinks = @component.component_links
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @component }
    end
  end

  # GET /components/new
  # GET /components/new.json
  def new
	if user_type == 'admin'
		@title = @header = 'Новый компонент'
		@component = Component.new
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @component }
		end
	else
		redirect_to '/404'
	end
  end

  # GET /components/1/edit
  def edit
	if user_type == 'admin'
		@title = @header = 'Изменение компонента'
		@component = Component.find(params[:id])
		@componentTypes = ComponentType.order('name ASC')
	else
		redirect_to '/404'
	end
  end

  # POST /components
  # POST /components.json
  def create
	if user_type == 'admin'
		componentTypeName = params[:component][:type_name].strip
		if componentTypeName != '' 
			componentType = ComponentType.find_by_name(componentTypeName)
			componentType = ComponentType.create(:name => componentTypeName) if componentType == nil
			params[:component][:component_type_id] = componentType.id 
		end
		
		@component = Component.new(params[:component])

		respond_to do |format|
		  if @component.save
			format.html { redirect_to @component, :notice => 'Компонент успешно добавлен' }
			format.json { render :json => @component, :status => :created, :location => @component }
		  else
			format.html { render :action => "new" }
			format.json { render :json => @component.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # PUT /components/1
  # PUT /components/1.json
  def update
    @component = Component.find(params[:id])
	if user_type == 'admin'
		respond_to do |format|
		  if @component.update_attributes(params[:component])
			format.html { redirect_to @component, :notice => 'Компонент успешно обновлён' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit" }
			format.json { render :json => @component.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # DELETE /components/1
  # DELETE /components/1.json
  def destroy
	if user_type == 'admin'
		@component = Component.find(params[:id])
		@component.destroy

		respond_to do |format|
		  format.html { redirect_to components_url }
		  format.json { head :no_content }
		end
	else
		redirect_to '/404'
	end
  end
end
