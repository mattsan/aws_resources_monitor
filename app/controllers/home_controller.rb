class HomeController < ApplicationController
  def index
    @instances = Ec2.new.describe_instances.sort_by {|i| i.launch_time }
  end
end
