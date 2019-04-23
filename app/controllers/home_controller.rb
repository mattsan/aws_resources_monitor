class HomeController < ApplicationController
  def index
    ec2 = Ec2.new('default')
    @instances = ec2.describe_instances.sort_by {|i| i.launch_time }
  end
end
