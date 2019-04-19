class Ec2
  def describe_instances
    client = Aws::EC2::Client.new(region: 'ap-northeast-1')

    client.describe_instances
  end
end
