class Ec2
  Instance = Struct.new('Instance', :id, :name, :state, :launch_time)
  def describe_instances
    client = Aws::EC2::Client.new(region: 'ap-northeast-1')

    filters = [
      {
        name: 'instance-state-name',
        values: ['running']
      },
      {
        name: 'tag:stage',
        values: ['staging']
      },
      {
        name: 'tag:component',
        values: %w(hr recruiter entry admin ops)
      }
    ]
    client
      .describe_instances(filters: filters)
      .reservations
      .flat_map(&:instances)
      .map {|i|
        Instance.new(
          i.instance_id,
          i.tags.select {|tag| tag.key == 'Name' }.map(&:value).join,
          i.state.name,
          i.launch_time.localtime
        )
      }
  end
end
