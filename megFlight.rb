require './megFlight/init'

file = ARGV[0]

if File.exist? file
  file = File.expand_path(file)
  identifier = ARGV[1]
  title = ARGV[2]
  subtitle = ARGV[3]
  host_url = ARGV[4]

  deployment_dir = File.join(['megflight', identifier])

  options = {
    :ipa => file,
    :identifier => identifier,
    :title => title,
    :subtitle => subtitle,
    :host_url => host_url
  }

  tmp_deployment_path = MegFlight.new(options).create_package
  if tmp_deployment_path
    # create deployment dir if it not exists yet
    prefix_path = File.dirname(file)
    full_deployment_dir = File.join [prefix_path, deployment_dir]
    if File.exists? full_deployment_dir
      FileUtils.remove_dir(full_deployment_dir)
    end
    FileUtils.mkdir_p(full_deployment_dir) 
    # copy all files from tmp_deployment_path to deployment_dir
    system "cp -a #{tmp_deployment_path}/* #{full_deployment_dir}"
  end
else
  puts "error: file not found '#{file}'"
  exit 1
end
