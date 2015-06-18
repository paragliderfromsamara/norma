class MessagesController < ApplicationController
  include MessagesHelper
  require 'mail'
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.find_all_by_folder_id(current_folder[1], :order => 'created_at DESC')
	
	render :layout => 'mailbox'

  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])
	 
	@mail = Mail.new(@message.raw_mail)
    render :layout => 'mailbox'
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new
	@message_type = params[:message_type]
	@message_to = Message.find_by_id(params[:message_id])
	@message_id = 0 if @message_to == nil
	@message_id = @message_to.id if @message_to != nil
    render :layout => 'mailbox'
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
	render :layout => 'mailbox'
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])

	back_to = "/messages?folder=2"
    respond_to do |format|
      if @message.save
		
			if MessageTo.output_mail(@message).deliver 
				@message.update_attributes(:folder_id => 3, :sent_date => Time.now)
				@message.save
				back_to = "/messages?folder=3"
			end
		format.html { redirect_to back_to, :notice => 'Message was successfully created.' }
        format.json { render :json => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.json { render :json => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, :notice => 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @message.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def save_as_draft
	 params[:message][:folder_id] = 5
	 @message = Message.new(params[:message])
	 
	 
      if @message.save
		redirect_to '/messages?folder=5', :notice => 'Message was successfully created.'
      else
		render :action => "new"
        
      end
  end
  
  def send_mails
	
  end
  
  def return_to_folder
	i = 0
		params[:message].each do |prm|
			i += 1
			if prm[1] != "no"
				message = Message.find_by_id(prm[1])
				if message != nil
					message.update_attributes(:folder_id => message.old_folder_id)
				end
			end
		end
		redirect_to :back
  end
  
  def change_folder
	if params[:to_folder] != nil and params[:to_folder] != ''
		folder_id = (params[:to_folder]).to_i
		i = 0
		params[:message].each do |prm|
			i += 1
			if prm[1] != "no"
				message = Message.find_by_id(prm[1])
				
				if message != nil
					old_folder = message.folder_id
					message.update_attributes(:folder_id => folder_id, :old_folder_id => old_folder)
				end
			end
		end
	
		redirect_to "/messages?folder=#{folder_id.to_s}"
	else
		redirect_to :back
	end
  end
  
  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
  
  def clean_folder

	messages = Message.find_all_by_folder_id(params[:folder_id])
	messages.each do |message|
		message.destroy
	end
	redirect_to :back
  end

  def new_reply
	@message_to = Message.find_by_id(params[:id])
	if @message_to != nil
		@message = Message.new(
							   :to => @message_to.from, 
							   :subject => "RE: '#{@message_to.subject}'"
							   )
		render :layout => 'mailbox'
	else
		redirect_to new_message_path
	end
  end
end
