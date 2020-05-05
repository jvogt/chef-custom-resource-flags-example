# Define your list of props that will be used as command line flags 
flag_props = [
  {name: :some_string, type: String, default: 'somevalue'},
  {name: :some_bool,   type: [TrueClass, FalseClass], default: false},
]

# Iterate over above list to generate properties
flag_props.each do |prop|
  property prop[:name], prop[:type], default: prop[:default]
end

# Define other props that won't be used as command line flags
property :debug, [TrueClass, FalseClass], default: false

# Define 'create' action
action :create do

  # First iterate over flag_props to create array of flags
  flags = []
  flag_props.each do |prop|
    flag_name = prop[:name].to_s

    # Get the compiled value for this property
    compiled_val = new_resource.instance_variable_get('@' + flag_name)
    
    # Handle different types by generating different flags
    case compiled_val
    when TrueClass, FalseClass
      if compiled_val == true
        flag = '--' + flag_name
      end
    when String
      flag = '--' + flag_name + '=' + compiled_val
    end

    # Add generated flag to array of flags
    flags.push(flag)
  end

  # # NOTE: you can use this to step into a pry session (does not work in test kitchen)
  # require 'pry'; binding.pry

  # Convert array of flags to string
  flags = flags.join(' ')

  # Quick example of using above non-flag property
  if new_resource.debug
    Chef::Log.warn("Debug output: generated flags: #{flags}")
  end

  # Do work with the generated flags string
  execute 'run my command' do
    command "/bin/echo '#{flags}'"
  end
end

