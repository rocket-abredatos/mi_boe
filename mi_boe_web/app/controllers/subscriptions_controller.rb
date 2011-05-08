class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  skip_authorization_check :only => [:index]
  
  # GET /users/:user_id/subscriptions
  # GET /users/:user_id/subscriptions.xml
  def index
    @subscriptions = Subscription.find_all_by_user_id(current_user.id)
    authorize! :read, @subscriptions.first if @subscriptions.present?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscriptions }
    end
  end

  # GET /users/:user_id/subscriptions/new
  # GET /users/:user_id/subscriptions/new.xml
  def new
    @subscription = Subscription.new
    @subscription.user = current_user
    authorize! :new, @subscription

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /users/:user_id/subscriptions/:subscription_id/edit
  def edit
    @subscription = Subscription.find(params[:id])
    authorize! :edit, @subscription
  end

  # POST /users/:user_id/subscriptions
  # POST /users/:user_id/subscriptions.xml
  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.user = current_user
    authorize! :create, @subscription

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to(user_subscriptions_url(current_user), :notice => 'Subscription was successfully created.') }
        format.xml  { render :xml => @subscription, :status => :created, :location => @subscription }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/:user_id/subscriptions/:subscription_id
  # PUT /users/:user_id/subscriptions/:subscription_id.xml
  def update
    @subscription = Subscription.find(params[:id])
    authorize! :update, @subscription

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to(user_subscriptions_url(current_user), :notice => 'Subscription was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:user_id/subscriptions/:subscription_id
  # DELETE /users/:user_id/subscriptions/:subscription_id.xml
  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to(user_subscriptions_url(current_user)) }
      format.xml  { head :ok }
    end
  end
end
