class Ec2
  Instance = Struct.new('Instance', :id, :image_id, :name, :state, :launch_time)

  attr_reader :profile

  def initialize(profile)
    @profile = profile
  end

  def describe_instances
    filters = [
      {
        name: 'instance-state-name',
        values: ['running']
      },
      {
        name: 'tag:stage',
        values: [profile]
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
          i.image_id,
          i.tags.select {|tag| tag.key == 'Name' }.map(&:value).join,
          i.state.name,
          i.launch_time.localtime
        )
      }
  end

  def client
    @client ||= Aws::EC2::Client.new(
      profile: @profile
    )
  end
end
